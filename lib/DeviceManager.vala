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

public class PN.DeviceManager : Object {
    protected NM.Client client;
    protected Gee.ArrayList<Device> devices;

    public signal void device_added (Device device);
    public signal void device_removed (Device device);

    private static DeviceManager? instance;

    public static NM.Client get_client () {
        return get_default ().client;
    }

    public static unowned DeviceManager get_default () {
        if (instance == null) {
            instance = new DeviceManager ();
        }

        return instance;
    }

    construct {
        devices = new Gee.ArrayList<Device> ();

        try {
            client = new NM.Client ();
            client.device_added.connect (on_device_added);
            client.device_removed.connect (on_device_removed);

            client.get_devices ().@foreach ((device) => {
                var dev = Device.from_target (device);
                devices.add (dev);
            });
        } catch (Error e) {
            critical ("Could not connect to client: %s", e.message);
        }

        update_devices ();
    }

    public Gee.ArrayList<Device> get_devices () {
        return devices;
    }

    private void on_device_added (NM.Device device) {
        var dev = Device.from_target (device);
        if (dev == null) {
            return;
        }

        devices.add (dev);
        update_devices ();
        device_added (dev);
    }

    private void on_device_removed (NM.Device device) {
        var dev = get_device_for_target (device);
        if (dev == null) {
            return;
        }

        devices.remove (dev);
        update_devices ();
        device_removed (dev);
    }

    private Device? get_device_for_target (NM.Device target) {
        foreach (var device in devices) {
            if (device.compare_target (target)) {
                return device;
            }
        }

        return null;
    }

    private void update_devices () {
        var type_map = new Gee.HashMap<NM.DeviceType, bool> ();
        foreach (var device in devices) {
            var type = device.target.get_device_type ();
            type_map[type] = type_map.has_key (type);
        }

        foreach (var device in devices) {
            var type = device.target.get_device_type ();
            device.update_title (!type_map[type]);
        }
    }
}
