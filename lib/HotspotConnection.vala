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

public class PN.HotspotConnection : WirelessConnection {
    public NM.DeviceWifiCapabilities capabilities { get; construct; }

    public override string? id {
        owned get {
            return setting_connection.id;
        }

        set {
            string _id;
            if (value == null) {
                _id = get_default_hotspot_name ();
            } else {
                _id = value;
            }

            setting_connection.id = _id;
        }
    }

    public new string key {
        owned get {
            if (setting_wireless.mode == NM.SettingWireless.MODE_AP) {
                return setting_wireless_security.psk;
            } else {
                return setting_wireless_security.wep_key0;
            }
        }

        set {
            if (setting_wireless.mode == NM.SettingWireless.MODE_AP) {
                setting_wireless_security.psk = value;
            } else {
                setting_wireless_security.wep_key0 = value;
            }
        }
    }

    internal static string get_default_hotspot_name () {
        return Environment.get_host_name ();
    }

    public static bool get_connection_is_hotspot (NM.Connection connection) {
        var setting_connection = connection.get_setting_connection ();
        if (setting_connection == null || setting_connection.get_connection_type () != WirelessConnection.WIRELESS_TYPE) {
            return false;
        }

        var setting_wireless = connection.get_setting_wireless ();
        if (setting_wireless == null) {
            return false;
        }

        string mode = setting_wireless.get_mode ();
        if (mode != NM.SettingWireless.MODE_AP && mode != NM.SettingWireless.MODE_ADHOC) {
            return false;
        }

        var ip4_config = connection.get_setting_ip4_config ();
        if (ip4_config == null || ip4_config.get_method () != NM.SettingIP4Config.METHOD_SHARED) {
            return false;
        }

        return true;
    }

    construct {
        setting_ip4_config.method = NM.SettingIP4Config.METHOD_SHARED;

        if ((capabilities & NM.DeviceWifiCapabilities.AP) != 0) {
            setting_wireless.mode = NM.SettingWireless.MODE_AP;
            if ((capabilities & NM.DeviceWifiCapabilities.RSN) != 0) {
                set_wpa_key (setting_wireless_security);
                setting_wireless_security.add_proto ("rsn");
                setting_wireless_security.add_pairwise ("ccmp");
                setting_wireless_security.add_group ("ccmp");
            } else if ((capabilities & NM.DeviceWifiCapabilities.WPA) != 0) {
                set_wpa_key (setting_wireless_security);
                setting_wireless_security.add_proto ("wpa");
                setting_wireless_security.add_pairwise ("tkip");
                setting_wireless_security.add_group ("tkip");
            } else {
                set_wep_key (setting_wireless_security);
            }
        } else {
            setting_wireless.mode = NM.SettingWireless.MODE_ADHOC;
            set_wep_key (setting_wireless_security);
        }
    }

    public HotspotConnection (NM.DeviceWifiCapabilities capabilities) {
        Object (capabilities: capabilities);
    }

    public HotspotConnection.for_device (DeviceWifi device) {
        Object (capabilities: ((NM.DeviceWifi)device.target).get_capabilities ());
    }

    private static void set_wpa_key (NM.SettingWirelessSecurity setting) {
        setting.key_mgmt = "wpa-psk";
    }

    private static void set_wep_key (NM.SettingWirelessSecurity setting) {
        setting.key_mgmt = "none";
        setting.wep_key_type = NM.WepKeyType.PASSPHRASE;
    }
}
