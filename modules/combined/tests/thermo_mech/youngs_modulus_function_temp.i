# ---------------------------------------------------------------------------
# This test is designed to verify the ComputeVariableElasticConstantStress
# by varying the young's modulus with temperature. A constant strain is applied
# to the mesh in this case, and the stress varies with the changing elastic constants.
#
# Geometry: A single element cube in symmetry boundary conditions and pulled
#           at a constant displacement to create a constant strain in the x-direction.
#
# Temperature:  The temperature varies from 400K to 700K in this simulation by
#           100K each time step. The temperature is held constant in the last
#           timestep to ensure that the elasticity tensor components are constant
#           under constant temperature.
#
# Results: Because Poisson's ratio is set to zero, only the stress along the x
#          axis is non-zero.  The stress changes with temperature.
#
#    Temperature(K)   strain_{xx}(m/m)     Young's Modulus(Pa)   stress_{xx}(Pa)
#          400              0.001             10.0e6               1.0e4
#          500              0.001             10.0e6               1.0e4
#          600              0.001              9.94e6              9.94e3
#          700              0.001              9.93e6              9.93e3
#
#    The tensor mechanics results align exactly with the analytical results above
#    when this test is run with ComputeIncrementalSmallStrain.  When the test is
#    run with ComputeFiniteStrain, a 0.05% discrepancy between the analytical
#    strains and the simulation strain results is observed, and this discrepancy
#    is carried over into the calculation of the elastic stress.
#-------------------------------------------------------------------------

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
  order = FIRST
  family = LAGRANGE
[]

[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 1
  ny = 1
  nz = 1
[]

[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
  [./disp_z]
  [../]
  [./temp]
    initial_condition = 400
  [../]
[]

[AuxVariables]
  [./stress_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./elastic_strain_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Functions]
  [./temperature_function]
    type = PiecewiseLinear
    x = '1       4'
    y = '400   700'
  [../]
[]

[Kernels]
  [./heat]
    type = HeatConduction
    variable = temp
  [../]

  [./TensorMechanics]
    use_displaced_mesh = true
  [../]
[]


[AuxKernels]
  [./stress_xx]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xx
    index_i = 0
    index_j = 0
  [../]

 [./elastic_strain_xx]
    type = RankTwoAux
    rank_two_tensor = elastic_strain
    variable = elastic_strain_xx
    index_i = 0
    index_j = 0
    execute_on = timestep_end
  [../]
[]


[BCs]
  [./u_left_fix]
    type = PresetBC
    variable = disp_x
    boundary = left
    value = 0.0
  [../]
  [./u_bottom_fix]
    type = PresetBC
    variable = disp_y
    boundary = bottom
    value = 0.0
  [../]
  [./u_back_fix]
    type = PresetBC
    variable = disp_z
    boundary = back
    value = 0.0
  [../]
  [./u_pull_right]
    type = PresetBC
    variable = disp_x
    boundary = right
    value = 0.001
  [../]

  [./temp_bc_1]
    type = FunctionDirichletBC
    variable = temp
    boundary = '1 2 3 4'
    function = temperature_function
  [../]
[]

[Materials]
  [./elasticity_tensor]
    type = ComputeVariableIsotropicElasticityTensor
    temperature = temp
    youngs_modulus = 10.0e6
    poissons_ratio = 0.0
    block = 0
  [../]
  [./strain]
    type = ComputeIncrementalSmallStrain
    block = 0
  [../]
  [./stress]
    type = ComputeVariableElasticConstantStress
    block = 0
  [../]
  [./heat1]
    type = HeatConductionMaterial
    block = 0
    specific_heat = 1.0
    thermal_conductivity = 1.0
  [../]
[]

[Executioner]
  type = Transient

  #Preconditioned JFNK (default)
  solve_type = 'PJFNK'

  petsc_options       = '-snes_ksp_ew'
  petsc_options_iname = '-ksp_gmres_restart'
  petsc_options_value = '101'

  line_search = 'none'

  l_max_its = 30
  nl_max_its = 30
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-6
  l_tol = 1e-5
  start_time = 0.0
  end_time = 5
  dt = 1
[]

[Postprocessors]
  [./elastic_strain_xx]
    type = ElementAverageValue
    variable = elastic_strain_xx
  [../]
  [./elastic_stress_xx]
    type = ElementAverageValue
    variable = stress_xx
  [../]

  [./temp]
    type = AverageNodalVariableValue
    variable = temp
  [../]
[]

[Outputs]
  [./out]
    type = Exodus
    file_base = youngs_modulus_function_temp_out
  [../]
[]
