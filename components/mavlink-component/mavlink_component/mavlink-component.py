from dronekit import connect as connect_vehicle, Vehicle, VehicleMode
from time import sleep

ALTITUDE_OFFSET = .95


def connect(connectionstring: str) -> Vehicle:
    print("\nConnecting to vehicle on: %s" % connectionstring)
    vehicle = connect_vehicle(connectionstring, wait_ready=True)
    vehicle.wait_ready('autopilot_version')
    print("Autopilot Version: %s", vehicle.version)
    while not vehicle.is_armable:
        sleep(1)
    print("vehicle initialized...")

    return vehicle


def last_heartbeat_callback(self, attr_name, last_heartbeat):
    message = {
        "last_heartbeat": last_heartbeat
    }


def location_callback(self, attr_name, location):
    message = {
        "relative_alt": location.global_relative_frame.alt,
        "absolute_alt": location.global_frame.alt,
        "longitude": location.global_frame.lon,
        "latitude": location.global_frame.lat
    }


def attitude_callback(self, attr_name, attitude):
    message = {
        "pitch": attitude.pitch,
        "yaw": attitude.yaw,
        "roll": attitude.roll
    }


def heading_callback(self, attr_name, heading):
    message = {
        "heading": heading
    }


def velocity_callback(self, attr_name, velocity):
    message = {
        "x": velocity[0],
        "y": velocity[1],
        "z": velocity[2]
    }


def airspeed_callback(self, attr_name, airspeed):
    message = {
        "air_speed": airspeed
    }


def groundspeed_callback(self, attr_name, groundspeed):
    message = {
        "ground_speed": groundspeed
    }


def battery_callback(self, attr_name, battery):
    message = {
        "voltage": battery.voltage,
        "current": battery.current,
        "level": battery.level
    }


def attach_listeners(vehicle: Vehicle):
    vehicle.add_attribute_listener('last_heartbeat', last_heartbeat_callback)
    vehicle.add_attribute_listener('location', location_callback)
    vehicle.add_attribute_listener('attitude', attitude_callback)
    vehicle.add_attribute_listener('heading', heading_callback)
    vehicle.add_attribute_listener('velocity', velocity_callback)
    vehicle.add_attribute_listener('airspeed', airspeed_callback)
    vehicle.add_attribute_listener('groundspeed', groundspeed_callback)
    vehicle.add_attribute_listener('battery', battery_callback)
    sleep(1)


def arm(vehicle):
    vehicle.armed = True
    while not vehicle.armed:
        sleep(1)
    print("vehicle armed")


def takeoff(vehicle, absolute_altitude: int = 10):
    vehicle.mode = VehicleMode("GUIDED")
    arm(vehicle)
    vehicle.simple_takeoff(absolute_altitude)
    while vehicle.location.global_relative_frame.alt <= absolute_altitude * ALTITUDE_OFFSET:
        sleep(1)


def do_drone_stuff(vehicle):
    takeoff(vehicle)

    while True:
        sleep(1)


def main():
    import argparse

    parser = argparse.ArgumentParser(
        description='Mavlink to IPC connector.')
    parser.add_argument('connectionstring',
                        type=str,
                        help="vehicle connection target string. default = 127.0.0.1:14550")
    args = parser.parse_args()

    connectionstring = args.connectionstring

    vehicle = connect(connectionstring)
    attach_listeners(vehicle)

    do_drone_stuff(vehicle)


if __name__ == "__main__":
    main()
