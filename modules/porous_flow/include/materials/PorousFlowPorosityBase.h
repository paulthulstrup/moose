/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/

#ifndef POROUSFLOWPOROSITYBASE_H
#define POROUSFLOWPOROSITYBASE_H

#include "PorousFlowMaterialVectorBase.h"

//Forward Declarations
class PorousFlowPorosityBase;

template<>
InputParameters validParams<PorousFlowPorosityBase>();

/**
 * Base class Material designed to provide the porosity.
 */
class PorousFlowPorosityBase : public PorousFlowMaterialVectorBase
{
public:
  PorousFlowPorosityBase(const InputParameters & parameters);

protected:
  /// When calculating nodal porosity, use the strain at the nearest quadpoint to the node
  const bool _strain_at_nearest_qp;

  /// computed porosity at the nodes or quadpoints
  MaterialProperty<Real> & _porosity;

  /// old value of porosity
  MaterialProperty<Real> & _porosity_old;

  /// d(porosity)/d(PorousFlow variable)
  MaterialProperty<std::vector<Real> > & _dporosity_dvar;

  /// d(porosity)/d(grad PorousFlow variable)
  MaterialProperty<std::vector<RealGradient> > & _dporosity_dgradvar;
};

#endif //POROUSFLOWPOROSITYBASE_H
