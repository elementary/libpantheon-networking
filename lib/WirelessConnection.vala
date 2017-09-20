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

public class PN.WirelessConnection : NM.Connection, Object {
    internal const string WIRELESS_TYPE = "802-11-wireless";

    public NM.SettingConnection setting_connection { get; construct; }
    public NM.SettingWireless setting_wireless { get; construct; }
    public NM.SettingWirelessSecurity setting_wireless_security  { get; construct; }
    public NM.SettingIP4Config setting_ip4_config { get; construct; }

    public virtual string? id {
        owned get {
            return setting_connection.id;
        }

        set {
            if (value == null) {
                warning ("Attempted to set a null value for the WirelessConnection ID");
                return;
            }

            setting_connection.id = value;
        }
    }

    public bool autoconnect {
        get {
            return setting_connection.autoconnect;
        }

        set {
            setting_connection.autoconnect = value;
        }
    }

    public bool hidden {
        get {
            return setting_wireless.hidden;
        }

        set {
            setting_wireless.hidden = value;
        }
    }

    public virtual Bytes ssid {
        get {
            return setting_wireless.get_ssid ();
        }

        set {
            setting_wireless[NM.SettingWireless.SSID] = value;
        }
    }

    public virtual string key { get; set; }

    internal static bool validate_ssid (string ssid) {
        int length = ssid.length;
        return length <= 32;
    }

    internal static bool validate_key (string key) {
        int length = key.length;
        return length >= 8;
    }

    construct {
        setting_connection = new NM.SettingConnection ();
        setting_connection.type = WIRELESS_TYPE;

        setting_wireless_security = new NM.SettingWirelessSecurity ();

        setting_wireless = new NM.SettingWireless ();

        setting_ip4_config = new NM.SettingIP4Config ();
        setting_ip4_config.method = NM.SettingIP4Config.METHOD_AUTO;

        add_setting (setting_connection);
        add_setting (setting_wireless);
        add_setting (setting_wireless_security);
        add_setting (setting_ip4_config);
    }
}
