// LaplaceEq.C computes the solution for Laplace Equation of the electric
// Potential V
//
// Made by P.Thulstrup (Sunday, January 8, 2017)

#include "LaplaceEq.h"

template <>
InputParameters
validParams<LaplaceEq>()
{
  InputParameters params = validParams<Kernel>();

  params.addRequiredParam<Real>("resistance", "Resistance of the material");
  return params;
}

LaplaceEq::LaplaceEq(const InputParameters & parameters)
  : // You must call the constructor of the base class first
    Kernel(parameters),
    _resistance(getParam<Real>("resistance"))
{
}

Real
LaplaceEq::computeQpResidual()
{
  return _grad_u[_qp] * _grad_test[_i][_qp];
}

Real
LaplaceEq::computeQpJacobian()
{
  return _grad_phi[_j][_qp] * _grad_test[_i][_qp];
}
