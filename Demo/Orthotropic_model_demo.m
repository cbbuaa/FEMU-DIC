function out = Orthotropic_model_demo(Params_FEMU)
%
% Orthotropic_model_demo_0.m
%
% Model exported on Jan 12 2024, 00:13 by COMSOL 6.1.0.346.

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath('/Users/binchen/Desktop/FEMU-OPEN/Demo');

model.label('Orthotropic_model.mph');

model.param.set('Ex', Params_FEMU.Ex, 'Ex');
model.param.set('Ey', Params_FEMU.Ey, 'Ey');
model.param.set('vxy', Params_FEMU.vxy, 'vxy');
model.param.set('Gxy', Params_FEMU.Gxy, 'Shear modulus');
model.param.set('R', [num2str(Params_FEMU.R),' [mm]'], 'Radius');
model.param.set('theta', Params_FEMU.theta, 'Angle');
model.param.set('L', [num2str(Params_FEMU.L),' [mm]'], 'Length');

model.component.create('comp1', true);

model.component('comp1').geom.create('geom1', 2);

model.result.table.create('evl2', 'Table');
model.result.table.create('tbl1', 'Table');

model.component('comp1').mesh.create('mesh1');

model.component('comp1').geom('geom1').lengthUnit('mm');
model.component('comp1').geom('geom1').create('r1', 'Rectangle');
model.component('comp1').geom('geom1').feature('r1').set('base', 'center');
model.component('comp1').geom('geom1').feature('r1').set('size', {'10' 'L'});
model.component('comp1').geom('geom1').create('c1', 'Circle');
model.component('comp1').geom('geom1').feature('c1').set('r', 'R');
model.component('comp1').geom('geom1').create('dif1', 'Difference');
model.component('comp1').geom('geom1').feature('dif1').selection('input').set({'r1'});
model.component('comp1').geom('geom1').feature('dif1').selection('input2').set({'c1'});
model.component('comp1').geom('geom1').create('c2', 'Circle');
model.component('comp1').geom('geom1').feature('c2').set('type', 'curve');
model.component('comp1').geom('geom1').feature('c2').set('r', 'R+1.5');
model.component('comp1').geom('geom1').create('pard1', 'PartitionDomains');
model.component('comp1').geom('geom1').feature('pard1').set('partitionwith', 'objects');
model.component('comp1').geom('geom1').feature('pard1').selection('domain').set('dif1(1)', 1);
model.component('comp1').geom('geom1').feature('pard1').selection('object').set({'c2'});
model.component('comp1').geom('geom1').feature('fin').label('Form Assembly');
model.component('comp1').geom('geom1').feature('fin').set('action', 'assembly');
model.component('comp1').geom('geom1').run;
model.component('comp1').geom('geom1').run('fin');

model.component('comp1').coordSystem.create('sys2', 'Rotated');

model.component('comp1').physics.create('solid', 'SolidMechanics', 'geom1');
model.component('comp1').physics('solid').create('fix1', 'Fixed', 1);
model.component('comp1').physics('solid').feature('fix1').selection.set([2]);
model.component('comp1').physics('solid').create('disp1', 'Displacement1', 1);
model.component('comp1').physics('solid').feature('disp1').selection.set([3]);
model.component('comp1').physics('solid').create('bndl1', 'BoundaryLoad', 1);
model.component('comp1').physics('solid').feature('bndl1').selection.set([3]);

model.component('comp1').mesh('mesh1').create('bl1', 'BndLayer');
model.component('comp1').mesh('mesh1').create('ftri1', 'FreeTri');

model.result.table('evl2').label('Evaluation 2D');
model.result.table('evl2').comments('Interactive 2D values');
model.result.table('tbl1').comments('Line Integration 1');

model.component('comp1').view('view1').axis.set('xmin', -10.025641441345215);
model.component('comp1').view('view1').axis.set('xmax', 10.025641441345215);
model.component('comp1').view('view1').axis.set('ymin', -9.350000381469727);
model.component('comp1').view('view1').axis.set('ymax', 9.350000381469727);

model.component('comp1').pair('ap1').label('Identity Boundary Pair 1a');

model.component('comp1').coordSystem('sys2').set('inPlaneAngle', 'theta');

model.component('comp1').physics('solid').prop('Type2D').set('Type2D', 'PlaneStress');
model.component('comp1').physics('solid').prop('d').set('d', '1e-3');
model.component('comp1').physics('solid').feature('lemm1').set('SolidModel', 'Orthotropic');
model.component('comp1').physics('solid').feature('lemm1').set('Evector_mat', 'userdef');
model.component('comp1').physics('solid').feature('lemm1').set('Evector', {'Ex'; 'Ey'; '1e9'});
model.component('comp1').physics('solid').feature('lemm1').set('nuvector_mat', 'userdef');
model.component('comp1').physics('solid').feature('lemm1').set('nuvector', {'vxy'; '0.1'; '0.1'});
model.component('comp1').physics('solid').feature('lemm1').set('Gvector_mat', 'userdef');
model.component('comp1').physics('solid').feature('lemm1').set('Gvector', {'Gxy'; '1e9'; '1e9'});
model.component('comp1').physics('solid').feature('lemm1').set('Evect_mat', 'userdef');
model.component('comp1').physics('solid').feature('lemm1').set('nuvect_mat', 'userdef');
model.component('comp1').physics('solid').feature('lemm1').set('Gvect1_mat', 'userdef');
model.component('comp1').physics('solid').feature('lemm1').set('rho_mat', 'userdef');
model.component('comp1').physics('solid').feature('lemm1').set('rho', 610);
model.component('comp1').physics('solid').feature('lemm1').set('coordinateSystem', 'sys2');
model.component('comp1').physics('solid').feature('disp1').set('Direction', [1; 0; 0]);
model.component('comp1').physics('solid').feature('disp1').set('U0', {'0'; 'L/100'; '0'});
model.component('comp1').physics('solid').feature('bndl1').set('LoadType', 'TotalForce');
model.component('comp1').physics('solid').feature('bndl1').set('Ftot', [0; 950; 0]);
model.component('comp1').physics('solid').feature('bndl1').set('FperArea', [0; 950; 0]);

model.component('comp1').mesh('mesh1').feature('size').set('hauto', 2);
model.component('comp1').mesh('mesh1').run;

model.study.create('std1');
model.study('std1').create('stat', 'Stationary');

model.sol.create('sol1');
model.sol('sol1').study('std1');
model.sol('sol1').attach('std1');
model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').create('s1', 'Stationary');
model.sol('sol1').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature.remove('fcDef');

model.result.numerical.create('int1', 'IntLine');
model.result.numerical('int1').selection.set([3]);
model.result.numerical('int1').set('probetag', 'none');
model.result.create('pg4', 'PlotGroup2D');
model.result.create('pg5', 'PlotGroup2D');
model.result.create('pg6', 'PlotGroup2D');
model.result('pg4').create('surf1', 'Surface');
model.result('pg4').feature('surf1').set('expr', 'solid.eXX');
model.result('pg5').create('surf1', 'Surface');
model.result('pg5').feature('surf1').set('expr', 'solid.eYY');
model.result('pg6').create('surf1', 'Surface');
model.result('pg6').feature('surf1').set('expr', 'solid.elogxy');
model.result.export.create('data1', 'Data');
model.result.export.create('data2', 'Data');

model.sol('sol1').attach('std1');
model.sol('sol1').feature('st1').label('Compile Equations: Stationary');
model.sol('sol1').feature('v1').label('Dependent Variables 1.1');
model.sol('sol1').feature('s1').label('Stationary Solver 1.1');
model.sol('sol1').feature('s1').feature('dDef').label('Direct 1');
model.sol('sol1').feature('s1').feature('aDef').label('Advanced 1');
model.sol('sol1').feature('s1').feature('aDef').set('cachepattern', true);
model.sol('sol1').feature('s1').feature('fc1').label('Fully Coupled 1.1');
model.sol('sol1').runAll;

model.result.numerical('int1').set('table', 'tbl1');
model.result.numerical('int1').set('expr', {'solid.RFy'});
model.result.numerical('int1').set('unit', {'N'});
model.result.numerical('int1').set('descr', {'Reaction force, y-component'});
model.result.numerical('int1').set('const', {'solid.refpntx' '0' 'Reference point for moment computation, x-coordinate'; 'solid.refpnty' '0' 'Reference point for moment computation, y-coordinate'; 'solid.refpntz' '0' 'Reference point for moment computation, z-coordinate'});
model.result.numerical('int1').setResult;
model.result('pg4').feature('surf1').label('exx');
model.result('pg4').feature('surf1').set('const', {'solid.refpntx' '0' 'Reference point for moment computation, x-coordinate'; 'solid.refpnty' '0' 'Reference point for moment computation, y-coordinate'; 'solid.refpntz' '0' 'Reference point for moment computation, z-coordinate'});
model.result('pg4').feature('surf1').set('resolution', 'normal');
model.result('pg5').feature('surf1').label('eyy');
model.result('pg5').feature('surf1').set('const', {'solid.refpntx' '0' 'Reference point for moment computation, x-coordinate'; 'solid.refpnty' '0' 'Reference point for moment computation, y-coordinate'; 'solid.refpntz' '0' 'Reference point for moment computation, z-coordinate'});
model.result('pg5').feature('surf1').set('resolution', 'normal');
model.result('pg6').feature('surf1').label('exy');
model.result('pg6').feature('surf1').set('const', {'solid.refpntx' '0' 'Reference point for moment computation, x-coordinate'; 'solid.refpnty' '0' 'Reference point for moment computation, y-coordinate'; 'solid.refpntz' '0' 'Reference point for moment computation, z-coordinate'});
model.result('pg6').feature('surf1').set('resolution', 'normal');
model.result.export('data1').set('expr', {'solid.elogxx' 'solid.elogxy' 'solid.elogyy'});
model.result.export('data1').set('unit', {'1' '1' '1'});
model.result.export('data1').set('descr', {'Logarithmic strain tensor, xx-component' 'Logarithmic strain tensor, xy-component' 'Logarithmic strain tensor, yy-component'});
model.result.export('data1').set('const', {'solid.refpntx' '0' 'Reference point for moment computation, x-coordinate'; 'solid.refpnty' '0' 'Reference point for moment computation, y-coordinate'; 'solid.refpntz' '0' 'Reference point for moment computation, z-coordinate'});
model.result.export('data1').set('filename', fullfile(Params_FEMU.folder_Model_results,'Strain.csv'));
model.result.export('data1').set('separator', ',');
model.result.export('data2').set('expr', {'u' 'v'});
model.result.export('data2').set('unit', {'mm' 'mm'});
model.result.export('data2').set('descr', {'Displacement field, X-component' 'Displacement field, Y-component'});
model.result.export('data2').set('const', {'solid.refpntx' '0' 'Reference point for moment computation, x-coordinate'; 'solid.refpnty' '0' 'Reference point for moment computation, y-coordinate'; 'solid.refpntz' '0' 'Reference point for moment computation, z-coordinate'});
model.result.export('data2').set('filename', fullfile(Params_FEMU.folder_Model_results,'Disp.csv'));
model.result.export('data2').set('separator', ',');

model.result.export('data1').run
model.result.export('data2').run
out = model;
