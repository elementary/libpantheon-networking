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

public class PN.DeviceWifi : Device {
    public DeviceWifi (NM.DeviceWifi device) {
        Object (target: device);
    }

    public async void activate_hotspot_simple (string? id, Bytes ssid, string key, bool autoconnect) throws Error {
        var connection = new HotspotConnection.for_device (this);
        connection.id = id;
        connection.ssid = ssid;
        connection.key = key;
        connection.autoconnect = autoconnect;

        try {
            yield add_and_activate_connection (connection);
        } catch (Error e) {
            throw e;
        }
    }

    public bool get_is_hotspot () {
        bool is_hotspot = false;

        var ac = target.get_active_connection ();
        if (ac != null) {
            var connection = ac.get_connection ();
            if (connection != null) {
                is_hotspot = HotspotConnection.get_connection_is_hotspot (connection);
            }
        }

        return is_hotspot;
    }

    public Gee.ArrayList<NM.Connection> get_hotspot_connections () {
        var list = new Gee.ArrayList<NM.Connection> ();
        target.get_available_connections ().@foreach ((connection) => {
            if (HotspotConnection.get_connection_is_hotspot (connection)) {
                list.add (connection);
            }
        });

        return list;
    }
}
