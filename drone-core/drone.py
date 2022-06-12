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

class Flightmode(IntEnum):
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


############
##  DRONE ##
############

class Drone:
    def __init__(self):
        pass
    
    def switch_mode(self, flightmode: Flightmode = Flightmode.STABILIZE):
        pass

    def arm(self):
        pass

    def disarm(self):
        pass

    def takeoff(self, height = 0):
        pass

    def move(self, movement: Movement = {0, 0, 0}):
        pass

    def goto(self, geocoords: GeoCoords = {0, 0}):
        pass




 
 
 
 
 
 
 
 









 






