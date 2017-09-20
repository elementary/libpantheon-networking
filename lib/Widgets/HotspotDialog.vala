/*-
 * Copyright (c) 2017 elementary LLC.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 * Authored by: Adam Bieńkowski <donadigos159@gmail.com>
 */

public class PN.Widgets.HotspotDialog : Gtk.Dialog {
    public NM.AccessPoint? active_ap { get; construct; }

    private const string NEW_ID = "0";
    private Gtk.Entry ssid_entry;
    private Gtk.Entry key_entry;

    private Gtk.Label ssid_label;
    private Gtk.Label key_label;

    private Gtk.ComboBoxText conn_combo;

    private Gtk.CheckButton check_btn;
    private Gtk.Label dumb;

    private Gtk.Button create_btn;

    private HashTable<string, NM.Connection> conn_hash;

    construct {
        deletable = false;
        resizable = false;
        border_width = 6;

        conn_hash = new HashTable<string, NM.Connection> (str_hash, str_equal);

        var content_area = this.get_content_area ();
        content_area.halign = content_area.valign = Gtk.Align.CENTER;

        var main_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var vbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);

        vbox.margin_left = vbox.margin_right = 6;

        var title = new Gtk.Label ("<span weight='bold' size='larger'>" + _("Wireless Hotspot") + "</span>");
        title.use_markup = true;
        title.halign = Gtk.Align.START;

        var image = new Gtk.Image.from_icon_name ("network-wireless-hotspot", Gtk.IconSize.DIALOG);
        image.valign = Gtk.Align.START;
        main_box.add (image);

        unowned string create_label;
        string header;
        if (active_ap != null) {
            string ssid_str = NM.Utils.ssid_to_utf8 (active_ap.get_ssid ().get_data ());
            header = _("Enabling Wireless Hotspot will disconnect from %s network.").printf (ssid_str);
            create_label = _("Switch to Hotspot");
        } else {
            header = _("Enabling Wireless Hotspot will disconnect from current network.");
            create_label =_("Enable Hotspot");
        }

        var cancel_btn = new Gtk.Button.with_label (_("Cancel"));
        create_btn = new Gtk.Button.with_label (create_label);

        create_btn.get_style_context ().add_class ("suggested-action");

        add_action_widget (cancel_btn, Gtk.ResponseType.CANCEL);
        add_action_widget (create_btn, Gtk.ResponseType.APPLY);

        var info_label = new Gtk.Label (header + "\n" + _("You will not be able to connect to a wireless network while Hotspot is active."));
        info_label.halign = Gtk.Align.START;
        info_label.margin_top = 6;
        info_label.use_markup = true;

        var grid = new Gtk.Grid ();
        grid.hexpand = true;
        grid.row_spacing = 6;
        grid.column_spacing = 12;
        grid.vexpand_set = true;

        ssid_entry = new Gtk.Entry ();
        ssid_entry.hexpand = true;
        ssid_entry.secondary_icon_tooltip_text = _("Network name needs to be less than 32 characters long.");
        ssid_entry.changed.connect (on_ssid_entry_changed);

        key_entry = new Gtk.Entry ();
        key_entry.hexpand = true;
        key_entry.visibility = false;
        key_entry.secondary_icon_tooltip_text = _("Password needs to be at least 8 characters long.");
        key_entry.changed.connect (on_key_entry_changed);

        check_btn = new Gtk.CheckButton.with_label (_("Show Password"));
        check_btn.toggled.connect (() => { key_entry.visibility = check_btn.active; });

        ssid_label = new Gtk.Label (_("Network Name:"));
        ssid_label.halign = Gtk.Align.END;

        key_label = new Gtk.Label (_("Password:"));
        key_label.halign = Gtk.Align.END;

        conn_combo = new Gtk.ComboBoxText ();
        conn_combo.append (NEW_ID, _("New…"));

        conn_combo.active_id = NEW_ID;
        conn_combo.changed.connect (on_combo_changed);

        var conn_label = new Gtk.Label (_("Connection:"));
        conn_label.halign = Gtk.Align.END;

        grid.attach (conn_label, 0, 0, 1, 1);
        grid.attach_next_to (conn_combo, conn_label, Gtk.PositionType.RIGHT, 1, 1);

        dumb = new Gtk.Label ("");

        grid.attach_next_to (ssid_label, conn_label, Gtk.PositionType.BOTTOM, 1, 1);
        grid.attach_next_to (ssid_entry, ssid_label, Gtk.PositionType.RIGHT, 1, 1);
        grid.attach_next_to (key_label, ssid_label, Gtk.PositionType.BOTTOM, 1, 1);
        grid.attach_next_to (key_entry, key_label, Gtk.PositionType.RIGHT, 1, 1);
        grid.attach_next_to (dumb, key_label, Gtk.PositionType.BOTTOM, 1, 1);
        grid.attach_next_to (check_btn, dumb, Gtk.PositionType.RIGHT, 1, 1);

        vbox.add (title);
        vbox.add (info_label);
        vbox.add (grid);

        on_combo_changed ();
        ssid_entry.text = HotspotConnection.get_default_hotspot_name ();

        main_box.add (vbox);
        content_area.add (main_box);
        show_all ();
    }

    public HotspotDialog (NM.AccessPoint? active_ap) {
        Object (active_ap: active_ap);
    }

    public HotspotDialog.from_device (DeviceWifi device) {
        var target = (NM.DeviceWifi)device.target;
        Object (active_ap: target.get_active_access_point ());

        foreach (var connection in device.get_hotspot_connections ()) {
            add_available_connection (connection);
        }
    }

    public bool add_available_connection (NM.Connection connection) {
        string uuid = connection.get_uuid ();

        var setting_wireless = connection.get_setting_wireless ();
        if (setting_wireless == null) {
            critical ("Provided connection does not contain a wireless setting (NM.SettingWireless)");
            return false;
        }

        var ssid = setting_wireless.get_ssid ();
        string name = NM.Utils.ssid_to_utf8 (ssid.get_data ());
        conn_combo.append (uuid, name);
        conn_hash.insert (uuid, connection);
        return true;
    }

    public Bytes get_ssid () {
        var bytes = new Bytes (get_ssid_str ().data);
        return bytes;
    }

    public string get_ssid_str () {
        return ssid_entry.text;
    }

    public string get_key () {
        return key_entry.get_text ();
    }

    public NM.Connection? get_selected_connection () {
        string? id = conn_combo.get_active_id ();
        if (id == null) {
            return null;
        }

        return conn_hash[id];
    }

    private void on_combo_changed () {
        string? secret = null;
        var selected = get_selected_connection ();
        if (selected != null) {
            var setting_wireless_security = selected.get_setting_wireless_security ();

            if (setting_wireless_security != null) {
                string key_mgmt = setting_wireless_security.get_key_mgmt ();
                if (key_mgmt == "none") {
                    secret = setting_wireless_security.get_wep_key (0);
                } else if (key_mgmt == "wpa-psk" || key_mgmt == "wpa-none") {
                    secret = setting_wireless_security.get_psk ();
                }

                if (secret == null) {
                    var remote_connection = (NM.RemoteConnection)selected;
                    update_secrets.begin (remote_connection);
                }
            }

            if (conn_combo.get_active_id () != NEW_ID) {
                var setting_wireless = selected.get_setting_wireless ();
                if (setting_wireless != null) {
                    ssid_entry.text = NM.Utils.ssid_to_utf8 (setting_wireless.get_ssid ().get_data ());
                    if (secret == null) {
                        secret = "";
                    }

                    key_entry.text = secret;
                }
            }
        } else {
            key_entry.text = "";
            ssid_entry.text = "";
        }
    }

    private void on_ssid_entry_changed () {
        string ssid = ssid_entry.text;
        bool ssid_valid = WirelessConnection.validate_ssid (ssid);
        if (ssid_valid) {
            ssid_entry.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "");
        } else {
            ssid_entry.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "process-error-symbolic");
        }

        string key = key_entry.text;
        create_btn.sensitive = ssid_valid && ssid.length > 0 && WirelessConnection.validate_key (key) && key.length > 0;
    }

    private void on_key_entry_changed () {
        string key = key_entry.text;
        bool key_valid = WirelessConnection.validate_key (key);
        if (key_valid) {
            key_entry.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "");
        } else if (key_entry.text.length > 0) {
            key_entry.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "process-error-symbolic");
        }

        string ssid = ssid_entry.text;
        create_btn.sensitive = WirelessConnection.validate_ssid (ssid) && ssid.length > 0 && key_valid && key.length > 0;
    }

    private async void update_secrets (NM.RemoteConnection connection) {
        try {
            var variant = yield connection.get_secrets_async (NM.SettingWireless.SECURITY_SETTING_NAME, null);
            connection.update_secrets (NM.SettingWireless.SECURITY_SETTING_NAME, variant);
            on_combo_changed ();
        } catch (Error e) {
            critical (e.message);
        }
    }
}
