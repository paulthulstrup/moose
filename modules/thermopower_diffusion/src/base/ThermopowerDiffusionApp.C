#include "AppFactory.h"
#include "Factory.h"
#include "Moose.h"
#include "MooseSyntax.h"
#include "ThermopowerDiffusionApp.h"
#include "ExampleDirac.h"

// Include Kernels
#include "LaplaceEq.h"
#include "ThermoPowerDiffusion.h"

// Include Material
#include "SheetParam.h"

template <>
InputParameters
validParams<ThermopowerDiffusionApp>()
{
  InputParameters params = validParams<MooseApp>();

  params.set<bool>("use_legacy_uo_initialization") = false;
  params.set<bool>("use_legacy_uo_aux_computation") = false;
  return params;
}

ThermopowerDiffusionApp::ThermopowerDiffusionApp(InputParameters parameters)
  : MooseApp(parameters)
{
  srand(processor_id());

  Moose::registerObjects(_factory);
  ThermopowerDiffusionApp::registerObjects(_factory);

  Moose::associateSyntax(_syntax, _action_factory);
  ThermopowerDiffusionApp::associateSyntax(_syntax, _action_factory);
}

ThermopowerDiffusionApp::~ThermopowerDiffusionApp()
{
}

void
ThermopowerDiffusionApp::registerObjects(Factory & factory)
{
  // Register any custom objects you have built on the MOOSE Framework
  registerKernel(LaplaceEq);
  registerKernel(ThermoPowerDiffusion);

  registerMaterial(SheetParam);
  registerDiracKernel(ExampleDirac);
}

void
ThermopowerDiffusionApp::registerApps()
{
  registerApp(ThermopowerDiffusionApp);
}

void
ThermopowerDiffusionApp::associateSyntax(Syntax & /*syntax*/,
                                         ActionFactory & /*action_factory*/)
{
}
