within Buildings.Fluid.FMI.ExportContainers;
block ReplaceableFourPort
  "Container to export thermofluid flow models with four ports as an FMU"
  extends Buildings.Fluid.FMI.ExportContainers.PartialFourPort;
  replaceable Buildings.Fluid.Interfaces.PartialFourPort com
    constrainedby Buildings.Fluid.Interfaces.PartialFourPort(
      redeclare final package Medium1 = Medium1,
      redeclare final package Medium2 = Medium2,
      final allowFlowReversal1=allowFlowReversal1,
      final allowFlowReversal2=allowFlowReversal2)
    "Component that holds the actual model"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Sources.RealExpression dpCom1(y=com.port_a1.p - com.port_b1.p)
    if use_p_in1 "Pressure drop of the component for Medium1"
    annotation (Placement(transformation(extent={{-40,46},{-20,66}})));


  Modelica.Blocks.Sources.RealExpression dpCom2(y=com.port_a2.p - com.port_b2.p)
    if use_p_in2 "Pressure drop of the component for Medium2"
    annotation (Placement(transformation(extent={{-40,-66},{-20,-46}})));


protected
  Buildings.Fluid.FMI.Adaptors.Inlet bouIn1(
    redeclare final package Medium=Medium1,
    final allowFlowReversal=allowFlowReversal1,
    final use_p_in=use_p_in1) "Boundary model for inlet of Medium1"
    annotation (Placement(transformation(extent={{-80,30},{-60,10}})));

  Buildings.Fluid.FMI.Adaptors.Outlet bouOut1(
    redeclare final package Medium=Medium1,
    final allowFlowReversal=allowFlowReversal1,
    final use_p_in=use_p_in1) "Boundary model for outlet of Medium1"
    annotation (Placement(transformation(extent={{60,30},{80,10}})));

  Adaptors.Inlet                     bouIn2(
    redeclare final package Medium = Medium2,
    final allowFlowReversal=allowFlowReversal2,
    final use_p_in=use_p_in2) "Boundary model for outlet of Medium2"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=180,
        origin={70,-20})));

  Adaptors.Outlet                     bouOut2(
    redeclare final package Medium = Medium2,
    final allowFlowReversal=allowFlowReversal2,
    final use_p_in=use_p_in2) "Boundary model for outlet of Medium2"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-70,-20})));

  Modelica.Blocks.Math.Feedback pOut1
    if use_p_in1 "Pressure at component outlet for Medium1"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));

  Modelica.Blocks.Math.Feedback pOut2
    if use_p_in2 "Pressure at component outlet for Medium2"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={0,-80})));

equation
  connect(bouIn1.port_b, com.port_a1) annotation (Line(points={{-60,20},{-10,20},
          {-10,6}},         color={0,127,255}));
  connect(inlet1, bouIn1.inlet)
    annotation (Line(points={{-110,20},{-81,20}}, color={0,0,255}));
  connect(com.port_b1, bouOut1.port_a) annotation (Line(points={{10,6},{10,20},{
          60,20}},      color={0,127,255}));
  connect(bouIn1.p, pOut1.u1)
    annotation (Line(points={{-70,31},{-70,80},{-8,80}}, color={0,127,127}));
  connect(pOut1.y, bouOut1.p)
    annotation (Line(points={{9,80},{70,80},{70,32}}, color={0,0,127}));
  connect(bouOut1.outlet, outlet1)
    annotation (Line(points={{81,20},{110,20}}, color={0,0,255}));
  connect(inlet2, bouIn2.inlet)
    annotation (Line(points={{110,-20},{81,-20}}, color={0,0,255}));
  connect(pOut2.y, bouOut2.p)
    annotation (Line(points={{-9,-80},{-70,-80},{-70,-32}}, color={0,0,127}));
  connect(bouIn2.p, pOut2.u1)
    annotation (Line(points={{70,-31},{70,-80},{8,-80}}, color={0,127,127}));
  connect(bouIn2.port_b, com.port_a2)
    annotation (Line(points={{60,-20},{10,-20},{10,-6}}, color={0,127,255}));
  connect(com.port_b2, bouOut2.port_a) annotation (Line(points={{-10,-6},{-10,-20},
          {-60,-20}}, color={0,127,255}));
  connect(dpCom2.y, pOut2.u2)
    annotation (Line(points={{-19,-56},{0,-56},{0,-72}}, color={0,0,127}));
  connect(bouOut2.outlet, outlet2)
    annotation (Line(points={{-81,-20},{-110,-20}}, color={0,0,255}));
  connect(dpCom1.y, pOut1.u2)
    annotation (Line(points={{-19,56},{0,56},{0,72}}, color={0,0,127}));
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
</html>"));
end ReplaceableFourPort;
