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

public class PN.StaticWEPConnection : WirelessConnection {
    public enum StaticWEPAuthType {
        UNKNOWN,
        OPEN_SYSTEM,
        SHARED_KEY;

        public string to_string () {
            string str;
            switch (this) {
                case OPEN_SYSTEM:
                    str = "open";
                    break;
                case SHARED_KEY:
                    str = "shared";
                    break;
                default:
                    str = "unknown";
                    break;
            }

            return str;
        }

        public static StaticWEPAuthType from_string (string str) {
            StaticWEPAuthType type;
            switch (str) {
                case "open":
                    type = OPEN_SYSTEM;
                    break;
                case "shared":
                    type = SHARED_KEY;
                    break;
                default:
                    type = UNKNOWN;
                    break;
            }

            return type;
        }
    }

    public StaticWEPAuthType auth_type { get; construct; }
    public uint key_index { get; construct; }

    public override string key {
        get {
            return setting_wireless_security.get_wep_key (key_index);
        }

        set {
            setting_wireless_security.set_wep_key (key_index, value);
        }
    }

    construct {
        setting_wireless_security.key_mgmt = "none";
        setting_wireless_security.auth_alg = auth_type.to_string ();
    }

    public StaticWEPConnection (StaticWEPAuthType auth_type, uint key_index = 0) {
        Object (auth_type: auth_type, key_index: key_index);
    }
}
