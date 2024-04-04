import '../utils/images.dart';

List<ProviderServicesModel> providerServices = getProviderServices();

class ProviderServicesModel {
  String serviceImage;
  String serviceName;
  int servicePrice;

  ProviderServicesModel(this.serviceImage, this.serviceName, this.servicePrice);
}

List<ProviderServicesModel> getProviderServices() {
  List<ProviderServicesModel> list = [];
  list.add(ProviderServicesModel(sofa, "Drain Cleaning", 750));
  list.add(ProviderServicesModel(kitchen, "Pipe Repair and Replacement", 1000));
  list.add(ProviderServicesModel(bathroom, "Gas Plumbing", 1250));
  list.add(ProviderServicesModel(carpet, "Pipefitting", 750));
  list.add(ProviderServicesModel(home, "Water Heater Installation", 1000));
  return list;
}
List<ProviderServicesModel> getPlumberProviderServices() {
  List<ProviderServicesModel> list = [];
  list.add(ProviderServicesModel(sofa, "Drain Cleaning", 750));
  list.add(ProviderServicesModel(kitchen, "Pipe Repair and Replacement", 1000));
  list.add(ProviderServicesModel(bathroom, "Gas Plumbing", 1250));
  list.add(ProviderServicesModel(carpet, "Pipefitting", 750));
  list.add(ProviderServicesModel(home, "Water Heater Installation", 1000));
  return list;
}
List<ProviderServicesModel> getCleaningProviderServices() {
  List<ProviderServicesModel> list = [];
  list.add(ProviderServicesModel(sofa, "Sofa Cleaning", 750));
  list.add(ProviderServicesModel(kitchen, "Kitchen Cleaning", 1000));
  list.add(ProviderServicesModel(bathroom, "Bathroom Cleaning", 1250));
  list.add(ProviderServicesModel(carpet, "Carpet Cleaning", 750));
  list.add(ProviderServicesModel(home, "Full House Cleaning", 1000));
  return list;
}
List<ProviderServicesModel> getElectricianProviderServices() {
  List<ProviderServicesModel> list = [];
  list.add(ProviderServicesModel(sofa, "Maintenance Electricians", 750));
  list.add(ProviderServicesModel(kitchen, "Construction Electricians", 1000));
  list.add(ProviderServicesModel(bathroom, "Low Voltage Electricians", 1250));
  list.add(ProviderServicesModel(carpet, "High Voltage Electricians", 750));
  list.add(ProviderServicesModel(home, "Renewable Energy Electricians", 1000));
  return list;
}
List<ProviderServicesModel> getPaintingProviderServices() {
  List<ProviderServicesModel> list = [];
  list.add(ProviderServicesModel(sofa, "Landscape Paintings", 750));
  list.add(ProviderServicesModel(kitchen, "Portraits", 1000));
  list.add(ProviderServicesModel(bathroom, "Mural Art", 1250));
  list.add(ProviderServicesModel(carpet, "Faux Finishes", 750));
  list.add(ProviderServicesModel(home, "Abstract Art", 1000));
  return list;
}
List<ProviderServicesModel> getCarpentersProviderServices() {
  List<ProviderServicesModel> list = [];
  list.add(ProviderServicesModel(sofa, "Cabinetmaking", 750));
  list.add(ProviderServicesModel(kitchen, "Framing", 1000));
  list.add(ProviderServicesModel(bathroom, "Trim Carpentry", 1250));
  list.add(ProviderServicesModel(carpet, "Custom Woodworking", 750));
  list.add(ProviderServicesModel(home, "Restoration Carpentry", 1000));
  return list;
}