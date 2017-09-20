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

namespace PN.Enums {
    public static unowned string device_type_to_string (NM.DeviceType type) {
        unowned string str;

        switch (type) {
            case NM.DeviceType.ETHERNET:
                str = _("Ethernet");
                break;
            case NM.DeviceType.WIFI:
                str = _("Wi-Fi");
                break;
            case NM.DeviceType.UNUSED1:
            case NM.DeviceType.UNUSED2:
                str = _("Not used");
                break;
            case NM.DeviceType.BT:
                str = _("Bluetooth");
                break;
            case NM.DeviceType.OLPC_MESH:
                str = _("OLPC XO");
                break;
            case NM.DeviceType.WIMAX:
                str = _("WiMAX Broadband");
                break;
            case NM.DeviceType.MODEM:
                str = _("Modem");
                break;
            case NM.DeviceType.INFINIBAND:
                str = _("InfiniBand device");
                break;
            case NM.DeviceType.BOND:
                str = _("Bond master");
                break;
            case NM.DeviceType.VLAN:
                str = _("VLAN Interface");
                break;
            case NM.DeviceType.ADSL:
                str = _("ADSL Modem");
                break;
            case NM.DeviceType.BRIDGE:
                str = _("Bridge master");
                break;
            case NM.DeviceType.UNKNOWN:
            default:
                str = _("Unknown");
                break;
        }

        return str;
    }

    public static string device_state_to_icon_name (NM.DeviceState state) {
        string icon_name;

        switch (state) {
            case NM.DeviceState.ACTIVATED:
                icon_name =  "user-available";
                break;
            case NM.DeviceState.DISCONNECTED:
                icon_name = "user-busy";
                break;
            case NM.DeviceState.UNMANAGED:
                icon_name = "user-invisible";
                break;
            case NM.DeviceState.CONFIG:
            case NM.DeviceState.PREPARE:
            case NM.DeviceState.SECONDARIES:
            case NM.DeviceState.IP_CONFIG:
            case NM.DeviceState.IP_CHECK:
                icon_name = "user-away";
                break;
            case NM.DeviceState.NEED_AUTH:
                icon_name = "user-away";
                break;
            case NM.DeviceState.DEACTIVATING:
                icon_name = "user-away";
                break;
            case NM.DeviceState.FAILED:
                icon_name = "user-busy";
                break;
            default:
                icon_name = "user-offline";
                break;
        }

        return icon_name;
    }

    public static unowned string device_state_to_label (NM.DeviceState state) {
        unowned string label;

        switch (state) {
            case NM.DeviceState.ACTIVATED:
                label = _("Connected");
                break;
            case NM.DeviceState.DISCONNECTED:
                label = _("Disconnected");
                break;
            case NM.DeviceState.UNMANAGED:
                label = _("Unmanaged");
                break;
            case NM.DeviceState.CONFIG:
            case NM.DeviceState.PREPARE:
            case NM.DeviceState.SECONDARIES:
            case NM.DeviceState.IP_CONFIG:
            case NM.DeviceState.IP_CHECK:
                label = _("Connecting…");
                break;
            case NM.DeviceState.NEED_AUTH:
                label = _("Waiting for authentication");
                break;
            case NM.DeviceState.DEACTIVATING:
                label = _("Disconnecting...");
                break;
            case NM.DeviceState.FAILED:
                label = _("Failed to connect");
                break;
            default:
                label = _("Unknown");
                break;
        }

        return label;
    }
}
