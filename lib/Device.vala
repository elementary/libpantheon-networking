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

public class PN.Device : Object {
    public NM.Device target { get; construct; }

    public string icon_name { get; construct; }
    public string title { get; set; default = _("Unknown"); }
    public bool @virtual { get; construct; }
    public bool supported { get; construct; }

    internal static Device from_target (NM.Device target) {
        Device device;
        switch (target.get_device_type ()) {
            case NM.DeviceType.WIFI:
                device = new DeviceWifi ((NM.DeviceWifi)target);
                break;
            default:
                device = new Device (target);
                break;
        }

        return device;
    }

    construct {
        switch (target.get_device_type ()) {
            case NM.DeviceType.ETHERNET:
                icon_name = "network-wired";
                break;
            case NM.DeviceType.WIFI:
                icon_name = "network-wireless";
                break;
            case NM.DeviceType.MODEM:
                icon_name = "network-cellular";
            default:
                break;
        }

        string iface = target.get_iface ();
        @virtual = iface.has_prefix ("vmnet") || iface.has_prefix ("lo") || iface.has_prefix ("veth");

        supported = (target.get_capabilities () & NM.DeviceCapabilities.NM_SUPPORTED) != 0;
    }

    public Device (NM.Device target) {
        Object (target: target);
    }

    public bool compare_target (NM.Device other) {
        return target.get_udi () == other.get_udi ();
    }

    public bool compare (Device other) {
        return compare_target (other.target);
    }

    public async void add_and_activate_connection (NM.Connection connection) throws Error {
        var client = DeviceManager.get_client ();
        try {
            yield client.add_and_activate_connection_async (connection, target, null, null);
        } catch (Error e) {
            throw e;
        }
    }

    public async void activate_connection (NM.Connection connection) throws Error {
        try {
            var client = DeviceManager.get_client ();
            yield client.activate_connection_async (connection, target, null, null);
        } catch (Error e) {
            throw e;
        }
    }

    public NM.Connection? find_available_connection () {
        var ac = target.get_active_connection ();
        if (ac != null) {
            return ac.get_connection ();
        }

        NM.Connection? connection = null;
        target.get_available_connections ().@foreach ((conn) => {
            if (conn == null && conn.get_setting_connection () == null) {
                connection = conn;
            }
        });

        return connection;
    }

    public unowned string get_type_string () {
        return Enums.device_type_to_string (target.get_device_type ());
    }

    public string get_state_icon_name () {
        return Enums.device_state_to_icon_name (target.get_state ());
    }

    public unowned string get_state_label () {
        return Enums.device_state_to_label (target.get_state ());
    }

    public void get_activity_information (out uint64 sent, out uint64 received) throws FileError {
        sent = 0;
        received = 0;

        string iface = target.get_iface ();
        string contents;
        try {
            string tx_bytes_path = Path.build_filename ("/sys/class/net", iface, "statistics/tx_bytes");
            if (FileUtils.test (tx_bytes_path, FileTest.EXISTS)) {
                FileUtils.get_contents (tx_bytes_path, out contents);
                sent = uint64.parse (contents);
            }

            string rx_bytes_path = Path.build_filename ("/sys/class/net", iface, "statistics/rx_bytes");
            if (FileUtils.test (rx_bytes_path, FileTest.EXISTS)) {
                FileUtils.get_contents (rx_bytes_path, out contents);
                received = uint64.parse (contents);
            }
        } catch (FileError e) {
            throw e;
        }
    }

    internal virtual void update_title (bool use_type_name) {
        if (use_type_name) {
            title = get_type_string ();
        } else {
            string desc = target.get_description ();
            title = desc;
        }
    }
}
