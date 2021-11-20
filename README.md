# perdux_sample_swiftUI
REDUX like architecture sample for iOS (target 14.*)

Motivation:
- to share reactive architecture approach with single direction data flow and SOA

Layers
* Data
  * RestApi
* Business
  * Modules with PERDUX components  
* Preseintation
  * Containers
  * Views   
* Utils
  * Extensions
  * IoC
  * PERDUX 

Next Steps
- Add a ViewStates connected to the multiple business states
- Extract PERDUX to the separate module and  addd  it to the project with SPM
