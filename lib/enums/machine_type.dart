enum MachineType {
  CNC,
  LaserCutting,
  Printing;

  String toApiString() {
    switch (this) {
      case MachineType.CNC:
        return "cnc";
      case MachineType.LaserCutting:
        return "laser";
      case MachineType.Printing:
        return "printing";
    }
  }

  String toDisplayString() {
    switch (this) {
      case MachineType.CNC:
        return "CNC Milling";
      case MachineType.LaserCutting:
        return "Laser Cutting";
      case MachineType.Printing:
        return "3D Printing";
    }
  }

  static MachineType fromString(String type) {
    switch (type.toLowerCase()) {
      case "cnc":
        return MachineType.CNC;
      case "laser":
        return MachineType.LaserCutting;
      case "printing":
        return MachineType.Printing;
      default:
        throw ArgumentError('Invalid machine type: $type');
    }
  }
}