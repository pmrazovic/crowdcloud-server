require 'enum'

class AndroidSensorType < Enum
  AndroidSensorType.add_item :TYPE_ACCELEROMETER, 'Accelerometer'
  AndroidSensorType.add_item :TYPE_AMBIENT_TEMPERATURE, 'Ambient temperature'
  AndroidSensorType.add_item :TYPE_LIGHT, 'Light'
  AndroidSensorType.add_item :TYPE_GRAVITY, 'Gravity'
  AndroidSensorType.add_item :TYPE_GYROSCOPE, 'Gyroscope'
  AndroidSensorType.add_item :TYPE_LINEAR_ACCELERATION, 'Linear Acceleration'
  AndroidSensorType.add_item :TYPE_MAGNETIC_FIELD, 'Magnetic field'
  AndroidSensorType.add_item :TYPE_PRESSURE, 'Pressure'
  AndroidSensorType.add_item :TYPE_PROXIMITY, 'Proximity'
  AndroidSensorType.add_item :TYPE_RELATIVE_HUMIDITY, 'Relative humidity'
  AndroidSensorType.add_item :TYPE_ROTATION_VECTOR, 'Rotation vector'
  AndroidSensorType.add_item :TYPE_ORIENTATION, 'Orientation'
  AndroidSensorType.add_item :TYPE_TEMPERATURE, 'Temperature'
end