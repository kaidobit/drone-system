from dronekit import connect as connect_vehicle, Vehicle, VehicleMode
from time import sleep

ALTITUDE_OFFSET = .95
TOPIC = "drone/state"
state = {}


def connect(connectionstring: str) -> Vehicle:
    print("\nConnecting to vehicle on: %s" % connectionstring)
    vehicle = connect_vehicle(connectionstring, wait_ready=True)
    vehicle.wait_ready('autopilot_version')
    print("Autopilot Version: %s", vehicle.version)
    while not vehicle.is_armable:
        sleep(1)
    print("vehicle initialized")

    return vehicle


def last_heartbeat_callback(self, attr_name, last_heartbeat):
    state.update({
        "last_heartbeat": last_heartbeat
    })


def location_callback(self, attr_name, location):
    state.update({
        "location": {
            "relative_alt": location.global_relative_frame.alt,
            "absolute_alt": location.global_frame.alt,
            "longitude": location.global_frame.lon,
            "latitude": location.global_frame.lat
        }
    })


def attitude_callback(self, attr_name, attitude):
    state.update({
        "attitude": {
            "pitch": attitude.pitch,
            "yaw": attitude.yaw,
            "roll": attitude.roll
        }
    })


def heading_callback(self, attr_name, heading):
    state.update({
        "heading": heading
    })


def velocity_callback(self, attr_name, velocity):
    state.update({
        "velocity": {
            "x": velocity[0],
            "y": velocity[1],
            "z": velocity[2]
        }
    })


def airspeed_callback(self, attr_name, airspeed):
    state.update({
        "air_speed": airspeed
    })


def groundspeed_callback(self, attr_name, groundspeed):
    state.update({
        "ground_speed": groundspeed
    })


def battery_callback(self, attr_name, battery):
    state.update({
        "battery": {
            "voltage": battery.voltage,
            "current": battery.current,
            "level": battery.level
        }
    })


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


def arm(vehicle: Vehicle):
    vehicle.armed = True
    while not vehicle.armed:
        sleep(1)
    print("vehicle armed")


def takeoff(vehicle: Vehicle, absolute_altitude: int = 10):
    vehicle.mode = VehicleMode("GUIDED")
    arm(vehicle)
    vehicle.simple_takeoff(absolute_altitude)
    while vehicle.location.global_relative_frame.alt <= absolute_altitude * ALTITUDE_OFFSET:
        sleep(1)


# def publish_state(ipc_client):
#     from awsiot.greengrasscoreipc.model import (
#         PublishToTopicRequest,
#         PublishMessage,
#         BinaryMessage
#     )
#     import json
#
#     print(state)
#
#     request = PublishToTopicRequest()
#     request.topic = TOPIC
#     publish_message = PublishMessage()
#     publish_message.binary_message = BinaryMessage()
#     publish_message.binary_message.message = json.dumps(state, indent=2).encode('utf-8')
#     request.publish_message = publish_message
#     operation = ipc_client.new_publish_to_topic()
#     operation.activate(request)
#     future = operation.get_response()
#     future.result(1)


def do_vehicle_stuff():
    # import schedule

    while True:
        # schedule.run_pending()
        print("=================")
        print(state)
        sleep(1)


# def config_schduler(schedule_interval: int):
#     import schedule
#     import awsiot.greengrasscoreipc as ipc
#
#     ipc_client = ipc.connect()
#     schedule.every(schedule_interval).seconds.do(publish_state(ipc_client))


def main():
    import argparse

    parser = argparse.ArgumentParser(
        description='Mavlink to IPC connector.')
    parser.add_argument('connection_string',
                        type=str,
                        help="vehicle connection target string. default = 127.0.0.1:14550")
    # parser.add_argument('--schedule_interval', '-s',
    #                     default=1,
    #                     required=False,
    #                     type=int,
    #                     help="Interval for publishing state to IPC")
    args = parser.parse_args()

    connection_string = args.connection_string
    # schedule_interval = args.schedule_interval

    vehicle = connect(connection_string)
    attach_listeners(vehicle)
    # config_schduler(schedule_interval)

    do_vehicle_stuff()


if __name__ == "__main__":
    main()
