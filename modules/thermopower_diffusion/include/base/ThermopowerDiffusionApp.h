#ifndef THERMOPOWER_DIFFUSIONAPP_H
#define THERMOPOWER_DIFFUSIONAPP_H

#include "MooseApp.h"

class ThermopowerDiffusionApp;

template<>
InputParameters validParams<ThermopowerDiffusionApp>();

class ThermopowerDiffusionApp : public MooseApp
{
public:
  ThermopowerDiffusionApp(InputParameters parameters);
  virtual ~ThermopowerDiffusionApp();

  static void registerApps();
  static void registerObjects(Factory & factory);
  static void associateSyntax(Syntax & syntax, ActionFactory & action_factory);
};

#endif /* THERMOPOWER_DIFFUSIONAPP_H */
