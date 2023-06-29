within ;
model DryCoilDiscretized_FMU

    //Attempt to set initial conditions.
    package Medium1
      extends Buildings.Media.Water(T_default=273.15+22.5);
    end Medium1;

    package Medium2
      extends Buildings.Media.Air(T_default=273.15+20.9);
    end Medium2;



    parameter Real tau1 = 20
    "Time constant" annotation (Evaluate=false);

    parameter Real tau2 = 10
    "Time constant" annotation (Evaluate=false);

    parameter Real tau_m = 20
    "Time constant" annotation (Evaluate=false);

    parameter Modelica.Units.SI.ThermalConductance UA_nominal=200
    "Nominal power" annotation(Evaluate=false);

    parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal(start=1)=1
    "Nominal mass flow rate medium 1" annotation(Evaluate=false);

    parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal(start=1)=1
    "Nominal mass flow rate medium 2" annotation(Evaluate=false);


    parameter Modelica.Units.SI.Pressure dp1_nominal=2000
    "Pressure difference for medium 1" annotation (Evaluate=true);

    parameter Modelica.Units.SI.Pressure dp2_nominal=15
    "Pressure difference for medium 2" annotation (Evaluate=true);

  parameter Modelica.Units.SI.Length dh1=0.025 annotation (Evaluate=false);

  parameter Modelica.Units.SI.Length dh2=1 annotation (Evaluate=false);

  parameter Boolean allowFlowReversal1=false;
  parameter Boolean allowFlowReversal2=false;

  parameter Integer nReg=2 annotation(Evaluate=true);
  parameter Integer nPipPar=3 annotation(Evaluate=true);
  parameter Integer nPipSeg=4 annotation(Evaluate=true);

  Buildings.Fluid.HeatExchangers.DryCoilDiscretized Coil(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
      m1_flow_nominal=m1_flow_nominal,
      m2_flow_nominal=m2_flow_nominal,
      dp1_nominal=dp1_nominal,
      dp2_nominal=dp2_nominal,
      UA_nominal=UA_nominal,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      tau1=tau1,
      tau2=tau2,
      tau_m=tau_m,
      m1_flow_small=1E-3*m1_flow_nominal,
      m2_flow_small=1E-3*m2_flow_nominal,
      nReg=nReg,
      nPipPar=nPipPar,
      nPipSeg=nPipSeg,
      dh1=dh1,
      dh2=dh2,
      airSideFlowDependent=true,
      waterSideFlowDependent=true,
      waterSideTemperatureDependent=true)
    annotation (Placement(transformation(extent={{-12,-12},{10,10}})));
  Buildings.Fluid.FMI.Interfaces.Inlet inlet1(
    redeclare package Medium = Medium1,       use_p_in=false, allowFlowReversal=
       allowFlowReversal1)
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Fluid.FMI.Interfaces.Inlet inlet2(
    redeclare package Medium = Medium2,       use_p_in=false, allowFlowReversal=
       allowFlowReversal2)
    annotation (Placement(transformation(extent={{120,-30},{100,-10}})));
  Buildings.Fluid.FMI.Interfaces.Outlet outlet2(
    redeclare package Medium = Medium2,         use_p_in=false,
      allowFlowReversal=allowFlowReversal2)
    annotation (Placement(transformation(extent={{-100,-30},{-120,-10}})));
  Buildings.Fluid.FMI.Interfaces.Outlet outlet1(
    redeclare package Medium = Medium1,         use_p_in=false,
      allowFlowReversal=allowFlowReversal1)
    annotation (Placement(transformation(extent={{100,10},{120,30}})));
protected
  Buildings.Fluid.FMI.Adaptors.Inlet bouIn1(
    redeclare final package Medium=Medium1,
    final allowFlowReversal=allowFlowReversal1,
    final use_p_in=false)     "Boundary model for inlet of Medium1"
    annotation (Placement(transformation(extent={{-80,30},{-60,10}})));

  Buildings.Fluid.FMI.Adaptors.Outlet bouOut1(
    redeclare final package Medium=Medium1,
    final allowFlowReversal=allowFlowReversal1,
    final use_p_in=false)     "Boundary model for outlet of Medium1"
    annotation (Placement(transformation(extent={{60,30},{80,10}})));

  Buildings.Fluid.FMI.Adaptors.Inlet                     bouIn2(
    redeclare final package Medium = Medium2,
    final allowFlowReversal=allowFlowReversal2,
    final use_p_in=false)     "Boundary model for outlet of Medium2"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=180,
        origin={70,-20})));

  Buildings.Fluid.FMI.Adaptors.Outlet                     bouOut2(
    redeclare final package Medium = Medium2,
    final allowFlowReversal=allowFlowReversal2,
    final use_p_in=false)     "Boundary model for outlet of Medium2"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-70,-20})));

equation
  connect(inlet1, bouIn1.inlet)
    annotation (Line(points={{-110,20},{-81,20}}, color={0,0,255}));
  connect(inlet2, bouIn2.inlet)
    annotation (Line(points={{110,-20},{81,-20}}, color={0,0,255}));
  connect(bouOut2.outlet, outlet2)
    annotation (Line(points={{-81,-20},{-110,-20}}, color={0,0,255}));
  connect(bouOut1.outlet, outlet1)
    annotation (Line(points={{81,20},{110,20}}, color={0,0,255}));
  connect(bouOut2.port_a, Coil.port_b2) annotation (Line(points={{-60,-20},{-20,
          -20},{-20,-7.6},{-12,-7.6}}, color={0,127,255}));
  connect(bouIn1.port_b, Coil.port_a1) annotation (Line(points={{-60,20},{-20,20},
          {-20,5.6},{-12,5.6}}, color={0,127,255}));
  connect(Coil.port_b1, bouOut1.port_a) annotation (Line(points={{10,5.6},{10,6},
          {20,6},{20,20},{60,20}}, color={0,127,255}));
  connect(Coil.port_a2, bouIn2.port_b) annotation (Line(points={{10,-7.6},{10,-8},
          {20,-8},{20,-20},{60,-20}}, color={0,127,255}));
  annotation ( Documentation(info="<html>
<p>
Block that serves as a container to export a thermofluid flow component.
This block contains a replaceable model <code>com</code> that needs to
be redeclared to export any model that has as its base class
<a href=\"modelica://Buildings.Fluid.Interfaces.PartialTwoPort\">
Buildings.Fluid.Interfaces.PartialTwoPort</a>.
This allows exporting a large variety of thermofluid flow models
with a simple redeclare.
</p>
<p>
See for example
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.PressureDrop\">
Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.PressureDrop</a>
or
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.HeaterCooler_u\">
Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.HeaterCooler_u</a>
for how to use this block.
</p>
<p>
Note that this block must not be used if the instance <code>com</code>
sets a constant pressure. In such a situation, use
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.PartialTwoPort\">
Buildings.Fluid.FMI.ExportContainers.PartialTwoPort</a>
together with
<a href=\"modelica://Buildings.Fluid.FMI.Adaptors.Inlet\">
Buildings.Fluid.FMI.Adaptors.Inlet</a>
and
<a href=\"modelica://Buildings.Fluid.FMI.Adaptors.Outlet\">
Buildings.Fluid.FMI.Adaptors.Outlet</a>
and set the pressure to be equal to the port <code>p</code> of
<a href=\"modelica://Buildings.Fluid.FMI.Adaptors.Outlet\">
Buildings.Fluid.FMI.Adaptors.Outlet</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 8, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"), uses(Buildings(version="10.0.0")));
end DryCoilDiscretized_FMU;
