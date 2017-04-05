#ifndef SHEETPARAM_H
#define SHEETPARAM_H

#include "Material.h"

// Forward Declarations
class SheetParam;

template <> InputParameters validParams<SheetParam>();

class SheetParam : public Material {
public:
  SheetParam(const InputParameters &parameters);

protected:
  virtual void computeQpProperties();

  /// Variable values (none)

  /// Called Parameters
  Real _length_scale;
  Real _alpha_c;
  Real _beta_c;

  // New Property Declarations
  MaterialProperty<Real> &_alpha;
  MaterialProperty<Real> &_beta;
};

#endif
