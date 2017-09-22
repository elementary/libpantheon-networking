public static int main (string[] args) {
    var dm = PN.DeviceManager.get_default ();
    var devs = dm.get_devices ();
    foreach (var dev in devs) {
        message (dev.title);
    }

    return 0;
}
