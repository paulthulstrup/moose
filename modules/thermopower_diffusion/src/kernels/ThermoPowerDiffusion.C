// ThermoPowerDiffusion.C computes the solution for the Mitthal Thesis ('96)
//
// Couples both the Temperature with localized joules heating and a sinking term
//
// /!\ Beware: temperature squared is computed!!
//
// Made by P.Thulstrup (Sunday, January 20, 2017)

#include "ThermoPowerDiffusion.h"
#include <math.h>

template <> InputParameters validParams<ThermoPowerDiffusion>() {
  InputParameters params = validParams<Kernel>();
  params.addRequiredCoupledVar("some_variable", "Potential of the field");
  params.addRequiredParam<MaterialPropertyName>("Alpha_n", "Sinking Factor");
  params.addRequiredParam<MaterialPropertyName>("Beta_n",
                                                "Joules heating Factor");
  params.addRequiredParam<Real>("fridge", "Temperature of the fridge");
  return params;
}

ThermoPowerDiffusion::ThermoPowerDiffusion(const InputParameters &parameters)
    : // You must call the constructor of the base class first
      Kernel(parameters),
      _grad_V(coupledGradient("some_variable")),
      _alpha(getMaterialProperty<Real>("Alpha_n")),
      _beta(getMaterialProperty<Real>("Beta_n")),
      _fridge(getParam<Real>("fridge")) {}

Real ThermoPowerDiffusion::computeQpResidual() {

  // General form is:
  // (-L/2_rho)_grad^2_T^2

  return _grad_u[_qp] * _grad_test[_i][_qp] +
         _alpha[_qp] * _test[_i][_qp] * (pow(sqrt(std::abs(_u[_qp])), 4) - pow(sqrt(_fridge), 4)) -
         _beta[_qp] * _grad_V[_qp] * _grad_V[_qp] * _test[_i][_qp];
}
