// SheetParam.C computes the values for various values of our materials
//      entering the the beta term and computing the Lorentz number
//
// L: Lorentz number
// rho:
//
// Made by P.Thulstrup (Sunday, January 20, 2017)

#include "SheetParam.h"

template <> InputParameters validParams<SheetParam>() {
  InputParameters params = validParams<Material>();
  params.addClassDescription("Parameters for Material in 2D");
  params.addRequiredParam<Real>(
      "length_scale",
      "defines the base length scale of the problem in microns");
  params.addRequiredParam<Real>("Alpha",
                                "Constant for sinking dependant on the "
                                "properties of the mesh and the "
                                "material");
  params.addRequiredParam<Real>("Beta", "Constant for heating dependant on the "
                                        "properties of the mesh and the "
                                        "material");

  return params;
}

SheetParam::SheetParam(const InputParameters &parameters)
    : Material(parameters), _length_scale(getParam<Real>(
                                "length_scale")), // Scaling values to our mesh
      _alpha_c(getParam<Real>("Alpha")),          // Material property
      _beta_c(getParam<Real>("Beta")),
      _alpha(declareProperty<Real>("sinking")),
      _beta(declareProperty<Real>("heating"))

{}

void SheetParam::computeQpProperties() {

  // Scale all length dependant constant to or material
  _alpha[_qp] = _alpha_c / _length_scale;
  _beta[_qp] = _beta_c / _length_scale;
}
