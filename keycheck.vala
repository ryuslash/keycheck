/* keycheck --- Quickly check the unlocked status of a keyring.
 * Copyright (C) 2015  Tom Willemse
 *
 * keycheck is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * keycheck is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with keycheck.  If not, see <http://www.gnu.org/licenses/>.
 */
using Secret;

class KeyCheck : GLib.Object {
    public static Collection? getByName(Service service, string? name) {
        List<Collection> collections = service.get_collections();

        if (name == null) name = "";

        foreach (Collection collection in collections) {
            if (collection.label == name) {
                return collection;
            }
        }

        return null;
    }

    public static Service? getService() {
        try {
            return Service.get_sync(ServiceFlags.LOAD_COLLECTIONS);
        }
        catch (GLib.Error ex) {
            return null;
        }
    }

    public static int main(string[] args) {
        Service service = getService();

        if (service == null) {
            stderr.printf("Couldn't get the Secret service proxy.\n");
            return 1;
        }

        Collection collection = getByName(service, args[1]);

        if (collection == null) {
            stdout.printf("Unknown collection: %s\n", args[1]);
            return 1;
        }

        stdout.printf("%s", collection.locked ? "Locked" : "Unlocked");

        return 0;
    }
}
