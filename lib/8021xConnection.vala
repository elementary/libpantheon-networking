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

public class PN.8021xConnection : WirelessConnection {
    public enum 8021xAuthType {
        UNKNOWN,
        TLS,
        LEAP,
        PWD,
        FAST,
        TUNEL_TLS,
        PEAP;

        public string to_string () {
            string str;
            switch (this) {
                case TLS:
                    str = "tls";
                    break;
                case LEAP:
                    str = "leap";
                    break;
                case PWD:
                    str = "pwd";
                    break;
                case FAST:
                    str = "fast";
                    break;
                case TUNEL_TLS:
                    str = "ttls";
                    break;
                case PEAP:
                    str = "peap";
                    break;
                default:
                    return "unknown";
            }

            return str;
        }
    }

    public NM.Setting8021x setting_8021x { get; construct; }

    public 8021xAuthType auth_type { get; construct; }
    public bool phase2 { get; construct; }

    public string username {
        owned get {
            return setting_8021x.identity;
        }

        set {
            setting_8021x.identity = value;
        }
    }

    public string password {
        owned get {
            return setting_8021x.password;
        }

        set {
            setting_8021x.password = value;
        }
    }

    construct {
        setting_8021x = new NM.Setting8021x ();

        switch (auth_type) {
            case 8021xAuthType.TLS:
            case 8021xAuthType.PWD:
                if (phase2) {
                    setting_8021x.phase2_auth = auth_type.to_string ();
                } else {
                    setting_8021x.add_eap_method (auth_type.to_string ());
                }
            case 8021xAuthType.LEAP:
                setting_8021x.add_eap_method ("leap");
                break;
            case 8021xAuthType.FAST:
                setting_8021x.add_eap_method ("fast");
                break;
        }
    }

    public 8021xConnection (8021xAuthType auth_type, bool phase2) {
        Object (auth_type: auth_type, phase2: phase2);
    }
}
