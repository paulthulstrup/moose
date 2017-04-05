#ifndef THERMOPOWERDIFFUSION_H
#define THERMOPOWERDIFFUSION_H

#include "Kernel.h"

class ThermoPowerDiffusion;

template <> InputParameters validParams<ThermoPowerDiffusion>();

class ThermoPowerDiffusion : public Kernel {
public:
  ThermoPowerDiffusion(const InputParameters &parameters);

protected:
  virtual Real computeQpResidual() override;

private:
  const VariableGradient &_grad_V;
  const MaterialProperty<Real> &_alpha;
  const MaterialProperty<Real> &_beta;
  Real _fridge;
};

#endif
