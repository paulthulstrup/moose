#ifndef LAPLACEEQ_H
#define LAPLACEEQ_H

#include "Kernel.h"

// Forward Declarations
class LaplaceEq;

template <> InputParameters validParams<LaplaceEq>();

class LaplaceEq : public Kernel {
public:
  LaplaceEq(const InputParameters &parameters);

protected:
  virtual Real computeQpResidual() override;
  virtual Real computeQpJacobian() override;

private:
  Real _resistance;
};

#endif // LaplaceEq_H
