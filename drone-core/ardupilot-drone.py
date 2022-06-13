##################
##  DATACLASSES ##
##################


from dataclasses import dataclass


@dataclass
class GeoCoords:
    lat: float = 0
    long: float = 0

@dataclass
class Movement:
    north: int = 0
    east: int = 0
    down: int = 0



############
##  ENUMS ##
############


from enum import IntEnum


class ArduPilotFlightmode(IntEnum):
    # https://ardupilot.org/copter/docs/flight-modes.html
    STABILIZE  = 0,
    ACRO = 1,
    ALTHOLD = 2,
    AUTO = 3,
    GUIDED = 4,
    LOITER = 5
    RTL = 6
    CIRCLE = 7
    LAND = 9
    DRIFT = 11
    SPORT = 13
    FLIP = 14
    AUTOTUNE = 15
    POSHOLD = 16
    BRAKE = 17
    THROW = 18
    AVOID_ADSB = 19
    GUIDED_NOGPS = 20
    SMART_RTL = 21
    FLOWHOLD = 22
    FOLLOW = 23
    ZIGZAG = 24
    SYSTEMID = 25
    HELI_AUTOROTATE = 26
    AUTO_RTL = 27



################
## EXCEPTIONS ##
################


# https://mavlink.io/en/messages/common.html#MAV_RESULT


class TemporarilyRejectedException():
    pass

class DeniedException():
    pass

class UnsupportedException():
    pass

class FailedException():
    pass



############
##  DRONE ##
############


from pymavlink import mavutil


class ArduPilotDrone:
    def __init__(self):
        pass
    

    def connect(self, connection_string: str = "udp:127.0.0.1:14550", timeout: int = 5):
        self.connection = mavutil.mavlink_connection(connection_string)
        self.connection.wait_heartbeat(timeout = timeout)
        print("connected to flight controller")


    def wait_heartbeat(self, timeout: int = 5):
        self.connection.wait_heartbeat(timeout = timeout)


    def set_flightmode(self, flightmode: ArduPilotFlightmode = ArduPilotFlightmode.STABILIZE):
        # https://ardupilot.org/dev/docs/mavlink-get-set-flightmode.html
        command = mavutil.mavlink.MAV_CMD_DO_SET_MODE
        self.__sendLongCommand(
            command,
            param1 = 1,
            param2 = flightmode
        )

        self.__get_result_for_command(command)


    def arm(self, forceArm = 0):
        # https://mavlink.io/en/messages/common.html#MAV_CMD_COMPONENT_ARM_DISARM
        command = mavutil.mavlink.MAV_CMD_COMPONENT_ARM_DISARM

        self.__sendLongCommand(
            command,
            param1 = 1, param2 = forceArm)

        self.__get_result_for_command(command)


    def disarm(self, forceDisarm = 0):
        # https://mavlink.io/en/messages/common.html#MAV_CMD_COMPONENT_ARM_DISARM
        command = mavutil.mavlink.MAV_CMD_COMPONENT_ARM_DISARM

        self.__sendLongCommand(
            command,
            param1 = 1, param2 = forceDisarm)

        self.__get_result_for_command(command)


    def takeoff(self, altitude, pitch_degree = 0, yaw_degree = 0, latitude = 0, longitude = 0):
        # https://mavlink.io/en/messages/common.html#MAV_CMD_NAV_TAKEOFF
        command = mavutil.mavlink.MAV_CMD_NAV_TAKEOFF

        self.__sendLongCommand(
            command,
            param1 = pitch_degree,
            param4 = yaw_degree,
            param5 = latitude,
            param6 = longitude,
            param7 = altitude
        )

        self.__get_result_for_command(command)


    def moveToByMeters(self, movement: Movement = {0, 0, 0}):
        pass


    def goto(self, geocoords: GeoCoords = {0, 0}):
        pass


    def __sendLongCommand(self, command,
    param1 = 0, param2 = 0, param3 = 0,
    param4 = 0, param5 = 0, param6 = 0,
    param7 = 0):
        # https://mavlink.io/en/services/command.html
        self.connection.mav.command_long_send(
            self.connection.target_system,
            self.connection.target_component,
            command,
            0,
            param1, param2, param3,
            param4, param5, param6,
            param7
        )


    def __get_result_for_command(self, command):
        result = self.connection.recv_match(type = "COMMAND_ACK", blocking = True)
        while result.command != command:
            result = self.connection.recv_match(type = "COMMAND_ACK", blocking = True)
        return result
            


d = ArduPilotDrone()
d.connect()
d.arm()
d.set_flightmode(ArduPilotFlightmode.GUIDED)
d.takeoff(10, pitch_degree = 45, longitude = -35.363262, latitude = 149.165237)


 
 
 
 
 
 
 
 









 






