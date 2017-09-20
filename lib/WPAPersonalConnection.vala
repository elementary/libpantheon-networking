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

public class PN.WPAPersonalConnection : WirelessConnection {
    public new string key {
        owned get {
            return setting_wireless_security.psk;
        }

        set {
            setting_wireless_security.psk = value;
        }
    }

    construct {
        setting_wireless_security.key_mgmt = "wpa-psk";
        setting_wireless_security.add_proto ("wpa");
        setting_wireless_security.add_pairwise ("tkip");
        setting_wireless_security.add_group ("tkip");
    }
}
