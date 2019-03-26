/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 * Thierry S. Nouidui, LBNL              4/16/2018
 */

#include "FMUZoneExchange.h"
#include "FMUEnergyPlusStructure.h"

#include <stdlib.h>
#include <math.h>

void setGetVariables(
  FMUZone* fmuZon,
  fmi2ValueReference inputValueReferences[],
  fmi2Real inputValues[],
  size_t nInp,
  fmi2ValueReference outputValueReferences[],
  fmi2Real outputValues[],
  size_t nOut)
  {
    fmi2_status_t status;
    writeLog(3, "Setting real variables in EnergyPlus.");
    status = fmi2_import_set_real(
      fmuZon->ptrBui->fmu,
      inputValueReferences,
      nInp,
      inputValues);
    if (status != fmi2OK) {
      ModelicaFormatError("Failed to set variables for building FMU with name %s\n", fmuZon->ptrBui->name);
    }

    writeLog(3, "Getting real variables from EnergyPlus.");
    status = fmi2_import_get_real(
      fmuZon->ptrBui->fmu,
      outputValueReferences,
      nOut,
      outputValues);
    if (status != fmi2OK) {
      ModelicaFormatError("Failed to get variables for building FMU with name %s\n", fmuZon->ptrBui->name);
    }
  }

void FMUZoneExchange(
  void* object,
  double T,
  double X,
  double mInlets_flow,
  double TAveInlet,
  double QGaiRad_flow,
  double time,
  double* TRad,
  double* QConSen_flow,
  double* dQConSen_flow,
  double* QLat_flow,
  double* QPeo_flow,
  int* nextEventTimeDefined,
  double* tNext){

  FMUZone* zone = (FMUZone*) object;
  double inputValues[1];
  double outputValues[1];
  fmi2_event_info_t eventInfo;
  fmi2Status status;

  /* Emulate heat transfer to a surface at constant T=18 degC */
  /* *QConSen_flow = 10*((273.15+18)-T);*/
  /* snprintf(msg, 200, "local is %f\n", *QConSen_flow); */
  const double dT = 0.01; /* Increment for derivative approximation */
  double QConSenPer_flow;

  /* ModelicaFormatMessage("*** Entered FMUZoneExchange at t = %f  ", time); */


  FMUZone* tmpZon = malloc(sizeof(FMUZone)); /* fixme: this malloc is probably not needed */
  writeLog(3, "Exchanging data with EnergyPlus in FMUZoneExchange.");

  if ( tmpZon == NULL )
    ModelicaError("Not enough memory in FMUZoneExchange.c. to allocate memory for zone.");
  tmpZon=(FMUZone*)zone->ptrBui->zones[zone->index-1];
  /* Time need to be guarded against rounding error */
  /* *tNext = round((floor(time/3600.0)+1) * 3600.0); */
  writeLog(3, "Setting time in EnergyPlus.");
  status = fmi2_import_set_time(zone->ptrBui->fmu, time);
  if ( status != fmi2OK ) {
    ModelicaFormatError("Failed to set time in building FMU with name %s.",
    zone->ptrBui->name);
  }

  /* Forward difference for QConSen_flow */
  inputValues[0] = T - 273.15 + dT;
  setGetVariables(zone, tmpZon->inputValueReferences, inputValues, 1, tmpZon->outputValueReferences, outputValues, 1);
  QConSenPer_flow=outputValues[0];
  inputValues[0] = T - 273.15;
  setGetVariables(zone, tmpZon->inputValueReferences, inputValues, 1, tmpZon->outputValueReferences, outputValues, 1);
  *QConSen_flow=outputValues[0];
  *dQConSen_flow = (QConSenPer_flow-*QConSen_flow)/dT;

  /* Get next event time */
  writeLog(3, "Getting next event time.");
  status = fmi2_import_new_discrete_states(zone->ptrBui->fmu, &eventInfo);
  writeLog(3, "Checking status.");
  if (status != fmi2OK) {
    ModelicaFormatError("Failed during call to fmi2NewDiscreteStates for building FMU with name %s.",
    zone->ptrBui->name);
  }
  if(eventInfo.terminateSimulation == fmi2True){
    ModelicaFormatError("EnergyPlus requested to terminate the simulation for building = %s, zone = %s, time = %f.",
    zone->ptrBui->name, zone->name, time);
  }
  if(eventInfo.nextEventTimeDefined == fmi2False){
    *nextEventTimeDefined ==  fmi2False;
  }
  else{
    *nextEventTimeDefined ==  fmi2True;
    *tNext = eventInfo.nextEventTime;
    if (*tNext <= time + 1E-6){
      ModelicaFormatError("EnergyPlus requested at time = %f a next event time of %f for building = %s, zone = %s. Zero time steps are not supported. Check with support.",
      time, *tNext, zone->ptrBui->name, zone->name);
    }
  }

  *TRad = 293.15;
  *QLat_flow = 0;
  *QPeo_flow = 0;
  writeLog(3, "Returning from FMUZoneExchange.");
  return;
}
