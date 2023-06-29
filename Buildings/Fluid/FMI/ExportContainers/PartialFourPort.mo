within Buildings.Fluid.FMI.ExportContainers;
partial block PartialFourPort
  "Partial block to be used as a container to export a thermofluid flow model with four ports"
  replaceable package Medium1 =
    Modelica.Media.Interfaces.PartialMedium "Medium1 in the component"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Air "Moist air"),
        choice(redeclare package Medium = Buildings.Media.Water "Water"),
        choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15,
          X_a=0.40)
          "Propylene glycol water, 40% mass fraction")));

  replaceable package Medium2 =
    Modelica.Media.Interfaces.PartialMedium "Medium2 in the component"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Air "Moist air"),
        choice(redeclare package Medium = Buildings.Media.Water "Water"),
        choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15,
          X_a=0.40)
          "Propylene glycol water, 40% mass fraction")));

  parameter Boolean allowFlowReversal1 = false
    "= true to allow flow reversal for medium 1, false restricts to design direction (inlet -> outlet)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Boolean allowFlowReversal2 = false
    "= true to allow flow reversal for medium 2, false restricts to design direction (inlet -> outlet)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Boolean use_p_in1 = true
    "= true to use a pressure from connector 1, false to output Medium.p_default"
    annotation(Evaluate=true);

  parameter Boolean use_p_in2 = true
    "= true to use a pressure from connector 2, false to output Medium.p_default"
    annotation(Evaluate=true);

  Interfaces.Inlet inlet1(
    redeclare final package Medium = Medium1,
    final allowFlowReversal=allowFlowReversal1,
    final use_p_in=use_p_in1) "Fluid inlet for medium1"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));

  Interfaces.Outlet outlet1(
    redeclare final package Medium = Medium1,
    final allowFlowReversal=allowFlowReversal1,
    final use_p_in=use_p_in1) "Fluid outlet for medium1" annotation (Placement(
        transformation(extent={{100,10},{120,30}}), iconTransformation(extent={{
            100,-10},{120,10}})));


  Interfaces.Inlet inlet2(
    redeclare final package Medium = Medium2,
    final allowFlowReversal=allowFlowReversal2,
    final use_p_in=use_p_in2) "Fluid inlet for medium2"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={110,-20})));

  Interfaces.Outlet outlet2(
    redeclare final package Medium = Medium2,
    final allowFlowReversal=allowFlowReversal2,
    final use_p_in=use_p_in2) "Fluid outlet for medium2" annotation (Placement(
        transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-110,-20}),                           iconTransformation(extent={{-120,
            -30},{-100,-10}})));
 annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255}),
            Text(
          extent={{-151,147},{149,107}},
          textColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}),    Documentation(info="<html>
<p>
Partial model that can be used to export thermofluid flow models as an FMU.
This model only declares the inlet and outlet ports, the medium and
whether flow reversal is allowed.
</p>
<p>
See
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.ResistanceVolume\">
Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.ResistanceVolume</a>
for a block that extends this partial block.
</p>
</html>", revisions="<html>
<ul>
<li>
January 18, 2019, by Jianjun Hu:<br/>
Limited the media choice.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1050\">#1050</a>.
</li>
<li>
April 29, 2015, by Michael Wetter:<br/>
Redesigned to conditionally remove the pressure connector
if <code>use_p_in=false</code>.
</li>
<li>
November 8, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));

end PartialFourPort;
