within Buildings.Fluid.FixedResistances;
model Pipe "Pipe with finite volume discretization along flow path"

  extends Buildings.Fluid.FixedResistances.BaseClasses.PartialPipe(
   diameter=sqrt(4*m_flow_nominal/rho_nominal/v_nominal/Modelica.Constants.pi),
   dp_nominal=2*dpStraightPipe_nominal,
   res(dp(nominal=length*10)));
  // Because dp_nominal is a non-literal value, we set
  // dp.nominal=100 instead of the default dp.nominal=dp_nominal,
  // because the latter is ignored by Dymola 2012 FD 01.

  parameter Modelica.SIunits.Velocity v_nominal = 0.15
    "Velocity at m_flow_nominal (used to compute default diameter)";
  parameter Modelica.SIunits.Length roughness(min=0) = 2.5e-5
    "Absolute roughness of pipe, with a default for a smooth steel pipe (dummy if use_roughness = false)";
  final parameter Modelica.SIunits.Pressure dpStraightPipe_nominal=
      Modelica.Fluid.Pipes.BaseClasses.WallFriction.Detailed.pressureLoss_m_flow(
      m_flow=m_flow_nominal,
      rho_a=rho_nominal,
      rho_b=rho_nominal,
      mu_a=mu_nominal,
      mu_b=mu_nominal,
      length=length,
      diameter=diameter,
      roughness=roughness,
      m_flow_small=m_flow_nominal/100)
    "Pressure loss of a straight pipe at m_flow_nominal"
    annotation (Evaluate=true);

  parameter Boolean useMultipleHeatPort=false
    "= true to use one heat port for each segment of the pipe, false to use a single heat port for the entire pipe";

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conPipWal[nSeg](
      each G=2*Modelica.Constants.pi*lambdaIns*length/nSeg/Modelica.Math.log((
        diameter/2.0 + thicknessIns)/(diameter/2.0)))
    "Thermal conductance through pipe wall"
    annotation (Placement(transformation(extent={{-28,-38},{-8,-18}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector colAllToOne(m=nSeg) if
       not useMultipleHeatPort
    "Connector to assign multiple heat ports to one heat port" annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={-50,10})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a singleHeatPort if not
    useMultipleHeatPort
    "Single heat port that connects to outside of pipe wall (default, enabled when useMultipleHeatPort=false)"
    annotation (Placement(transformation(extent={{-60,16},{-40,36}}),
        iconTransformation(extent={{-10,50},{10,70}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a multipleHeatPort[nSeg] if
       useMultipleHeatPort
    "Multiple heat ports that connect to outside of pipe wall (enabled if useMultipleHeatPort=true)"
    annotation (Placement(transformation(extent={{-85,16},{-65,36}}),
        iconTransformation(extent={{-9,50},{11,70}})));
equation

  connect(conPipWal.port_b, vol.heatPort) annotation (Line(
      points={{-8,-28},{-1,-28}},
      color={191,0,0},
      smooth=Smooth.None));
  if useMultipleHeatPort then
    connect(multipleHeatPort, conPipWal.port_a) annotation (Line(
        points={{-75,26},{-75,-28},{-28,-28}},
        color={191,0,0},
        smooth=Smooth.None));
  else
    connect(colAllToOne.port_a, conPipWal.port_a) annotation (Line(
        points={{-50,4},{-50,-28},{-28,-28}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(colAllToOne.port_b, singleHeatPort) annotation (Line(
        points={{-50,16},{-50,26}},
        color={191,0,0},
        smooth=Smooth.None));

  end if;
  annotation (
    Diagram(graphics),
    Icon(graphics),
    defaultComponentName="pip",
    Documentation(info="<html>
<p>
Model of a pipe with flow resistance and heat exchange with environment.
</p>
<p>
If <code>useMultipleHeatPort=false</code> (default option), the pipe uses a single heat port 
for the heat exchange with the environment.
If <code>useMultipleHeatPort=true</code>, then one heat port for each segment of the pipe is
used for the heat exchange with the environment.
</p>
<p>
The default value for the parameter <code>diameter</code> is computed such that the flow velocity
is equal to <code>v_nominal=0.15</code> for a mass flow rate of <code>m_flow_nominal</code>.
Both parameters, <code>diameter</code> and <code>v_nominal</code>, can be overwritten
by the user.
The default value for <code>dp_nominal</code> is two times the pressure drop that the pipe
would have if it were straight with no fittings.
The factor of two that takes into account the pressure loss of fittings can be overwritten.
These fittings could also be explicitely modeled outside of this component using models from
the package
<a href=\"modelica://Modelica.Fluid.Fittings\">
Modelica.Fluid.Fittings</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 15, 2012 by Michael Wetter:<br>
Revised implementation and added default values.
</li>
<li>
February 12, 2012 by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"));
end Pipe;
