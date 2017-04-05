#ifndef CHSPLITVAR_H
#define CHSPLITVAR_H

#include "KernelGrad.h"

//Forward Declarations
class CHSplitVar;

template<>
InputParameters validParams<CHSplitVar>();

/**
 * Alternative Cahn-Hilliard split
 */
class CHSplitVar : public KernelGrad
{
public:
  CHSplitVar(const InputParameters & parameters);

protected:
  virtual RealGradient precomputeQpResidual();
  virtual RealGradient precomputeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

private:
  const unsigned int _var_c;
  const VariableGradient & _grad_c;
};

#endif //CHSPLITVAR_H
