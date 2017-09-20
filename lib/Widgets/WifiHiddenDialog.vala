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

public class PN.WifiHiddenDialog : Gtk.Dialog {
    public DeviceWifi device { get; construct; }

    private Gtk.Entry ssid_entry;
    private Gtk.Entry key_entry;

    private Gtk.Label ssid_label;
    private Gtk.Label key_label;

    private Gtk.ComboBoxText sec_combo;

    private Gtk.CheckButton check_btn;
    private Gtk.Label dumb;

    private Gtk.Button create_btn;

    construct {
        deletable = false;
        resizable = false;
        border_width = 6;

        var content_area = this.get_content_area ();
        content_area.halign = content_area.valign = Gtk.Align.CENTER;

        var main_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var vbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);

        vbox.margin_left = vbox.margin_right = 6;

        var title = new Gtk.Label ("<span weight='bold' size='larger'>" + _("Connect to a Hidden Network") + "</span>");
        title.use_markup = true;
        title.halign = Gtk.Align.START;

        var image = new Gtk.Image.from_icon_name ("network-wireless", Gtk.IconSize.DIALOG);
        image.valign = Gtk.Align.START;
        main_box.add (image);

        var cancel_btn = new Gtk.Button.with_label (_("Cancel"));
        create_btn = new Gtk.Button.with_label (_("Connect"));

        create_btn.get_style_context ().add_class ("suggested-action");

        add_action_widget (cancel_btn, Gtk.ResponseType.CANCEL);
        add_action_widget (create_btn, Gtk.ResponseType.APPLY);

        var info_label = new Gtk.Label (_("Connect to a specific Wi-Fi network by entering it's credentials"));
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

        sec_combo = new Gtk.ComboBoxText ();
        fill_sec_combo ();
        sec_combo.active = 0;

        var sec_label = new Gtk.Label (_("Security:"));
        sec_label.halign = Gtk.Align.END;

        dumb = new Gtk.Label ("");

        grid.attach (sec_label, 0, 0, 1, 1);
        grid.attach_next_to (sec_combo, sec_label, Gtk.PositionType.RIGHT, 1, 1);

        grid.attach_next_to (ssid_label, sec_label, Gtk.PositionType.BOTTOM, 1, 1);
        grid.attach_next_to (ssid_entry, ssid_label, Gtk.PositionType.RIGHT, 1, 1);
        grid.attach_next_to (key_label, ssid_label, Gtk.PositionType.BOTTOM, 1, 1);
        grid.attach_next_to (key_entry, key_label, Gtk.PositionType.RIGHT, 1, 1);
        grid.attach_next_to (dumb, key_label, Gtk.PositionType.BOTTOM, 1, 1);
        grid.attach_next_to (check_btn, dumb, Gtk.PositionType.RIGHT, 1, 1);

        vbox.add (title);
        vbox.add (info_label);
        vbox.add (grid);

        ssid_entry.text = HotspotConnection.get_default_hotspot_name ();

        main_box.add (vbox);
        content_area.add (main_box);
        show_all ();
    }

    public WifiHiddenDialog (DeviceWifi device) {
        Object (device: device);
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

    public NM.Utils.SecurityType get_security_type () {
        NM.Utils.SecurityType type;
        switch (sec_combo.get_active_id ()) {
            case "none":
                type = NM.Utils.SecurityType.NONE;
                break;
            case "static-wep":
                type = NM.Utils.SecurityType.STATIC_WEP;
                break;
            case "leap":
                type = NM.Utils.SecurityType.LEAP;
                break;
            case "dynamic-wep":
                type = NM.Utils.SecurityType.DYNAMIC_WEP;
                break;
            case "wpa-personal":
                type = NM.Utils.SecurityType.WPA_PSK;
                break;
            case "wpa-enterprise":
                type = NM.Utils.SecurityType.WPA_ENTERPRISE;
                break;
            default:
                type = NM.Utils.SecurityType.INVALID;
                break;
        }

        return type;
    }

    private void fill_sec_combo () {
        var capabilities = ((NM.DeviceWifi)device.target).get_capabilities ();
        if (NM.Utils.security_valid (NM.Utils.SecurityType.NONE, capabilities, false, false, 0, 0, 0)) {
            sec_combo.append ("none", _("Wifi/wired security"));
        }

        if (NM.Utils.security_valid (NM.Utils.SecurityType.STATIC_WEP, capabilities, false, false, 0, 0, 0)) {
            sec_combo.append ("static-wep", _("WEP 40/128-bit Key (Hex or ASCII)"));
        }

        if (NM.Utils.security_valid (NM.Utils.SecurityType.LEAP, capabilities, false, false, 0, 0, 0)) {
            sec_combo.append ("leap", _("LEAP"));
        }

        if (NM.Utils.security_valid (NM.Utils.SecurityType.DYNAMIC_WEP, capabilities, false, false, 0, 0, 0)) {
            sec_combo.append ("dynamic-wep", _("Dynamic WEP (802.1x)"));
        }

        if (NM.Utils.security_valid (NM.Utils.SecurityType.WPA_PSK, capabilities, false, false, 0, 0, 0) ||
            NM.Utils.security_valid (NM.Utils.SecurityType.WPA2_PSK, capabilities, false, false, 0, 0, 0)) {
            sec_combo.append ("wpa-personal", _("WPA & WPA2 Personal"));
        }

        if (NM.Utils.security_valid (NM.Utils.SecurityType.WPA_ENTERPRISE, capabilities, false, false, 0, 0, 0) ||
            NM.Utils.security_valid (NM.Utils.SecurityType.WPA2_ENTERPRISE, capabilities, false, false, 0, 0, 0)) {
            sec_combo.append ("wpa-enterprise", _("WPA & WPA2 Enterprise"));
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
}
