#!/bin/bash
INPUT="$1"
OUTPUT_CC="$1.cc"
OUTPUT_H="$1.h"
NAMESPACE="TSMS"

cp $INPUT $OUTPUT_CC

# Replace xgen namespaces
for i in `egrep "^ namespace f[fxb]{1}\{ class .*; \} $" ${SWIS_HOME}/common/translators/TSMSTranslator/generated/TacticalSeparationManagementService.h | cut -d' ' -f5 | cut -d';' -f1 ` ; do
	ns=`egrep "^ namespace f[fxb]{1}\{ class .*; \} $" ${SWIS_HOME}/common/translators/TSMSTranslator/generated/TacticalSeparationManagementService.h | grep " $i;" | cut -d' ' -f3 | cut -d'{' -f1`
	from="xgen::tsms::${i}"
	to="xgen::${ns}::${i}"
	if [[ "${i}" == "TrajectoryPointType" ]] ; then
		awk 'BEGIN{occ=1}!/xgen::tsms::TrajectoryPointType/{print}/xgen::tsms::TrajectoryPointType/{if(occ==0){sub("xgen::tsms::TrajectoryPointType", "xgen::fx::TrajectoryPointType", $0)}else{occ=occ-1}print}' < $OUTPUT_CC > .$OUTPUT_CC
		mv .$OUTPUT_CC $OUTPUT_CC
	elif [[ "${i}" == "TrajectoryType" ]] ; then
		awk 'BEGIN{occ=2}!/xgen::tsms::TrajectoryType/{print}/xgen::tsms::TrajectoryType/{if(occ==0){sub("xgen::tsms::TrajectoryType", "xgen::fx::TrajectoryType", $0)}else{occ=occ-1}print}' < $OUTPUT_CC > .$OUTPUT_CC
		mv .$OUTPUT_CC $OUTPUT_CC
	elif [[ "${i}" == "PointRangeType" ]] ; then
awk 'BEGIN{occ=1}!/xgen::tsms::PointRangeType/{print}/xgen::tsms::PointRangeType/{if(occ==0){sub("xgen::tsms::PointRangeType", "xgen::fx::PointRangeType", $0)}else{occ=occ-1}print}' < $OUTPUT_CC > .$OUTPUT_CC
		mv .$OUTPUT_CC $OUTPUT_CC
	else
		sed -i "s/${from}/${to}/g" $OUTPUT_CC
	fi
	if [ $? -ne 0 ]
	then
		echo "sed -i \"s/${from}/${to}/g\" $OUTPUT_CC"
	fi
done

# Replace CORBA namespaces
awk 'BEGIN{namespace="TSMS"}/void ConverterXmlToTSMS*/{split($0, a, ":");namespace=a[5]}!/ TSMS::T_/{print}/ TSMS::T_/{if(namespace!=""){gsub(/ TSMS/, " " toupper(namespace))}print}' $OUTPUT_CC > .$OUTPUT_CC
mv .$OUTPUT_CC $OUTPUT_CC

# Replace enums
for i in `grep "std::map<std::string, TSMS::T_" $OUTPUT_CC | cut -d ' ' -f 2 | cut -d ':' -f 3 | cut -d '>' -f 1` ; do
	file=`grep "enum $i" ${SWIS_HOME}/idl_interfaces/FourSightTypes/weaved/Spd*.h | cut -d ':' -f 1`
	ns=`echo ${file##*/} | cut -d '.' -f 1 | cut -c 4-`
	sed -i "s/TSMS::${i}/${ns}::${i}/g" $OUTPUT_CC
	awk 'BEGIN{namespace="TSMS"}/std::map<std::string, /{split($0, a, "[ :]");namespace=a[6]}!/"] = TSMS::E_/{print}/"] = TSMS::E_/{if(namespace!=""){gsub(/ TSMS/, " " toupper(namespace))}print}' $OUTPUT_CC > .$OUTPUT_CC
	mv .$OUTPUT_CC $OUTPUT_CC
done

# Create the .h file
echo "#ifndef COMPONENTS_COVERTER_XML_TO_${NAMESPACE}_H_
#define COMPONENTS_COVERTER_XML_TO_${NAMESPACE}_H_

#include <Spd${NAMESPACE}.h>
#include \"TacticalSeparationManagementService.h\"

class ConverterXmlTo${NAMESPACE} {

public:

	ConverterXmlTo${NAMESPACE}();

	virtual ~ConverterXmlTo${NAMESPACE}(){}
" > $OUTPUT_H
grep -v "#include" $OUTPUT_CC | grep "ConverterXmlTo${NAMESPACE}" >> $OUTPUT_H
sed -i 's/void/	static void/g' $OUTPUT_H
sed -i 's/_MAP()/_MAP();/g' $OUTPUT_H
sed -i 's/response)/response);/g' $OUTPUT_H
sed -i 's/ConverterXmlTo[A-Z]*:://g' $OUTPUT_H
echo "};
#endif /* COMPONENTS_COVERTER_XML_TO_${NAMESPACE}_H_ */" >> $OUTPUT_H

# FlightType in .h
sed -i "s/static void Convert ( xgen::fx::FlightType\& response_xml, FX::T_FLIGHT_TYPE \&response);/\/\/static void Convert ( xgen::fx::FlightType\& response_xml, FX::T_FLIGHT_TYPE \&response);/" $OUTPUT_H

# FlightType in .cc
sed -i "s/void ConverterXmlToTSMS::Convert ( xgen::fx::FlightType\& response_xml, FX::T_FLIGHT_TYPE \&response)/\/*void ConverterXmlToTSMS::Convert ( xgen::fx::FlightType\& response_xml, FX::T_FLIGHT_TYPE \&response)/" $OUTPUT_CC
sed -i "s/void ConverterXmlToTSMS::Convert ( xgen::fx::FlightIdentificationType\& response_xml, FX::T_FLIGHT_IDENTIFICATION_TYPE \&response)/*\/\n\nvoid ConverterXmlToTSMS::Convert ( xgen::fx::FlightIdentificationType\& response_xml, FX::T_FLIGHT_IDENTIFICATION_TYPE \&response)/" $OUTPUT_CC

# Constructor in .cc
echo "
ConverterXmlTo${NAMESPACE}::ConverterXmlTo${NAMESPACE}()
{" > .$OUTPUT_CC
awk '/INITIALIZE/{print "   " $NF}' $OUTPUT_H >> .$OUTPUT_CC
echo "}
" >> .$OUTPUT_CC
sed -i -ne "/T_1_ACCEPTED_FOR_ENV_TACTICAL_CONFLICT_DETECTION_0DENTRO0_SERVICE_COMPONENT_TYPES/ {p; r .${OUTPUT_CC}" -e ":a; n; / / {p; b}; ba}; p" $OUTPUT_CC
rm .${OUTPUT_CC}

# ServiceComponentTypes in .cc
echo "{
   // none
   if(response_xml.get_none().get()) {
      response.R_NONE_OR_REJECTED_OR_ACCEPTED_FOR_TACTICAL_CONFORMANCE_MONITORING_OR_ACCEPTED_FOR_TACTICAL_CONFLICT_DETECTION_OR_ACCEPTED_FOR_ENV_TACTICAL_CONFLICT_DETECTION_0DENTRO0_SERVICE_COMPONENT_TYPES_UNION.R_0_NONE(response_xml.get_none()->c_str());
   }

   // rejected
   if(response_xml.get_rejected().get()) {
      response.R_NONE_OR_REJECTED_OR_ACCEPTED_FOR_TACTICAL_CONFORMANCE_MONITORING_OR_ACCEPTED_FOR_TACTICAL_CONFLICT_DETECTION_OR_ACCEPTED_FOR_ENV_TACTICAL_CONFLICT_DETECTION_0DENTRO0_SERVICE_COMPONENT_TYPES_UNION.R_0_REJECTED(response_xml.get_rejected()->c_str());
   }

   // acceptedForTacticalConformanceMonitoring or acceptedForTacticalConflictDetection or acceptedForEnvTacticalConflictDetection
   if(response_xml.get_acceptedForTacticalConformanceMonitoring().get() || response_xml.get_acceptedForTacticalConflictDetection().get() || response_xml.get_acceptedForEnvTacticalConflictDetection().get()) {
      boost::shared_ptr<T_0_AFTCM_AND_AFTCD_AND_AFETCD_0DENTRO0_SCT> t_0_aftcm_and_aftcd_and_afetcd_0dentro0_sct(new T_0_AFTCM_AND_AFTCD_AND_AFETCD_0DENTRO0_SCT);

      // acceptedForTacticalConformanceMonitoring
      if(response_xml.get_acceptedForTacticalConformanceMonitoring().get()) {
         boost::shared_ptr<CORBA::Char *> buffer_acceptedForTacticalConformanceMonitoring(new CORBA::Char *);
         *buffer_acceptedForTacticalConformanceMonitoring = const_cast<CORBA::Char*>(response_xml.get_acceptedForTacticalConformanceMonitoring()->c_str());
         t_0_aftcm_and_aftcd_and_afetcd_0dentro0_sct -> R_ACCEPTED_FOR_TACTICAL_CONFORMANCE_MONITORING = T_AFTCM_0DENTRO0_SCT(1, buffer_acceptedForTacticalConformanceMonitoring.get(), false);
      }

      // acceptedForTacticalConflictDetection or acceptedForEnvTacticalConflictDetection
      if(response_xml.get_acceptedForTacticalConflictDetection().get() || response_xml.get_acceptedForEnvTacticalConflictDetection().get()) {

         boost::shared_ptr<T_AFTCD_OR_AFETCD_0DENTRO0_SCTU> t_aftcd_or_afetcd_0dentro0_sctu(new T_AFTCD_OR_AFETCD_0DENTRO0_SCTU);

         // acceptedForTacticalConflictDetection
         if(response_xml.get_acceptedForTacticalConflictDetection().get()) {
            boost::shared_ptr<CORBA::Char *> buffer_acceptedForTacticalConflictDetection(new CORBA::Char *);
            *buffer_acceptedForTacticalConflictDetection = const_cast<CORBA::Char*>(response_xml.get_acceptedForTacticalConflictDetection()->c_str());
            t_aftcd_or_afetcd_0dentro0_sctu -> R_1_ACCEPTED_FOR_TACTICAL_CONFLICT_DETECTION(T_1_AFTCD_0DENTRO0_SCT(1, buffer_acceptedForTacticalConflictDetection.get(), false));
         }

         // acceptedForEnvTacticalConflictDetection
         if(response_xml.get_acceptedForEnvTacticalConflictDetection().get()) {
            boost::shared_ptr<CORBA::Char *> buffer_acceptedForEnvTacticalConflictDetection(new CORBA::Char *);
            *buffer_acceptedForEnvTacticalConflictDetection = const_cast<CORBA::Char*>(response_xml.get_acceptedForEnvTacticalConflictDetection()->c_str());
            t_aftcd_or_afetcd_0dentro0_sctu -> R_1_ACCEPTED_FOR_ENV_TACTICAL_CONFLICT_DETECTION(T_1_AFETCD_0DENTRO0_SCT(1, buffer_acceptedForEnvTacticalConflictDetection.get(), false));
         }

         t_0_aftcm_and_aftcd_and_afetcd_0dentro0_sct -> R_ACCEPTED_FOR_TACTICAL_CONFLICT_DETECTION_OR_ACCEPTED_FOR_ENV_TACTICAL_CONFLICT_DETECTION_0DENTRO0_SERVICE_COMPONENT_TYPES_UNION = *t_aftcd_or_afetcd_0dentro0_sctu;

      }
      response.R_NONE_OR_REJECTED_OR_ACCEPTED_FOR_TACTICAL_CONFORMANCE_MONITORING_OR_ACCEPTED_FOR_TACTICAL_CONFLICT_DETECTION_OR_ACCEPTED_FOR_ENV_TACTICAL_CONFLICT_DETECTION_0DENTRO0_SERVICE_COMPONENT_TYPES_UNION.R_0_ACCEPTED_FOR_TACTICAL_CONFORMANCE_MONITORING_AND_ACCEPTED_FOR_TACTICAL_CONFLICT_DETECTION_AND_ACCEPTED_FOR_ENV_TACTICAL_CONFLICT_DETECTION(*t_0_aftcm_and_aftcd_and_afetcd_0dentro0_sct);
   }" > .$OUTPUT_CC
sed -i -ne "/ServiceComponentTypes/ {p; r .${OUTPUT_CC}" -e ":a; n; /^}/ {p; b}; ba}; p" $OUTPUT_CC
rm .${OUTPUT_CC}
