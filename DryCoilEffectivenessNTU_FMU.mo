within ;
model DryCoilEffectivenessNTU_FMU
  "Declaration of an FMU that exports an ideal heater or cooler with prescribed outlet temperature"
   extends Buildings.Fluid.FMI.ExportContainers.ReplaceableFourPort(
     redeclare replaceable package Medium1 = Buildings.Media.Water,
     redeclare replaceable package Medium2 = Buildings.Media.Air,
     allowFlowReversal1=allowFlowReversal,
     allowFlowReversal2=allowFlowReversal,
     redeclare final Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU com(
      m1_flow_nominal=m1_flow_nominal,
      m2_flow_nominal=m2_flow_nominal,
      dp1_nominal=dp1_nominal,
      dp2_nominal=dp2_nominal,
      configuration=configuration,
      Q_flow_nominal=Q_flow_nominal,
      T_a1_nominal=T_a1_nominal,
      T_a2_nominal=T_a2_nominal,
      r_nominal=r_nominal,
      use_Q_flow_nominal=false,
      eps_nominal=eps_nominal,
      m1_flow_small=1E-6*m1_flow_nominal,
      m2_flow_small=1E-6*m2_flow_nominal,
      linearizeFlowResistance1=true,
      linearizeFlowResistance2=true),
      use_p_in1=false,
      use_p_in2=false);

    parameter Real eps_nominal = 0.8 annotation(Evaluate=false);


    parameter Modelica.Units.SI.Power Q_flow_nominal=96000
    "Nominal power" annotation(Evaluate=false);
    parameter Modelica.Units.SI.Temperature T_a1_nominal=45+273.15
    "Temperature at nominal conditions as port a1" annotation(Evaluate=false);
    parameter Modelica.Units.SI.Temperature T_b1_nominal=30+273.15
    "Temperature at nominal conditions as port b1" annotation(Evaluate=false);
    parameter Modelica.Units.SI.Temperature T_a2_nominal=12+273.15
    "Temperature at nominal conditions as port a2" annotation(Evaluate=false);
    parameter Modelica.Units.SI.Temperature T_b2_nominal=21+273.15
    "Temperature at nominal conditions as port b2" annotation(Evaluate=false);
    parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal=1.53110
    "Nominal mass flow rate medium 1" annotation(Evaluate=false);
                                                              //
    parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal=10.66666666
    "Nominal mass flow rate medium 2" annotation(Evaluate=false);
                                                              //Q_flow_nominal/(1000*(T_b2_nominal-T_a2_nominal))


    parameter Modelica.Units.SI.Pressure dp1_nominal=2000
    "Pressure difference for medium 1" annotation (Evaluate=false);

    parameter Modelica.Units.SI.Pressure dp2_nominal=15
    "Pressure difference for medium 2" annotation (Evaluate=false);

    parameter Real r_nominal(
    min=0,
    max=1) = 2/3
    "Ratio between air-side and water-side convective heat transfer (hA-value) at nominal condition" annotation (Evaluate=false);


    parameter Boolean allowFlowReversal=false;

    parameter Buildings.Fluid.Types.HeatExchangerConfiguration configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow;


equation

  annotation (uses(Buildings(version="10.0.0"), Modelica(version="4.0.0")),
    experiment(
      StopTime=100,
      __Dymola_fixedstepsize=0.001,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentFlags(Advanced(
        InlineMethod=0,
        InlineOrder=2,
        InlineFixedStep=60)));
end DryCoilEffectivenessNTU_FMU;
