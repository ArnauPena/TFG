%% INPUT DATA

% Material properties
E = 200e9; % Pa

% Cross-section parameters
d = 110e-3; % m
tA = 5e-3; % m
a = 25e-3; % m
b = 75e-3; % m
tB = 3e-3; % m

% Other data
T = 15e3; % N
Vto = 70; % m/s
dto = 65; % m
Mt = 15800; % kg
sig_rot = 230e6; % Pa
g = 9.81; % m/s2

% Geometric data
H1 = 0.22; % m
H2 = 0.36; % m
H3 = 0.48; % m
H4 = 0.55; % m
H5 = 2.1; % m
L1 = 0.9; % m
L2 = 0.5; % m
L3 = 0.5; % m
L4 = 2.5; % m
L5 = 4.2; % m

% Angles of rods 1-6 & 2-7
sin_e16 = H1/sqrt(L2^2+H1^2);
cos_e16 = L2/sqrt(L2^2+H1^2);
sin_e27 = (H1+H2)/sqrt(L3^2+(H1+H2)^2);
cos_e27 = L3/sqrt(L3^2+(H1+H2)^2);
tan_e27 = sin_e27/cos_e27;

%% PREPROCESS

% Nodal coordinates
%  x(a,j) = coordinate of node a in the dimension j
data.x = [
      0,          H1; % Node 1
      0,       H1+H2; % Node 2
      0,    H1+H2+H3; % Node 3
      0, H1+H2+H3+H4; % Node 4
    -L1, H1+H2+H3+H4; % Node 5
];

% Nodal connectivities  
%  Tnod(e,a) = global nodal number associated to node a of element e
data.Tnod = [
    1, 2; % Element 1-2
    2, 3; % Element 2-3
    3, 4; % Element 3-4
    3, 5; % Element 3-5
];


% Material properties matrix
 AA = pi*d*tA;
 IzA = 1/4*pi*(((d+tA)/2)^4-((d-tA)/2)^4);
 AB = 2*a*tB+tB*(b-tB);
 IzB = 1/12*a*(b+tB)^3-2*(1/12*(a/2-tB/2)*(b-tB)^3);
 
%  mat(m,1) = Young modulus of material m
%  mat(m,2) = Section area of material m
%  mat(m,3) = Section inertia of material m
data.mat = [% Young M.        Section A.    Inertia
               E,               AA,        IzA;  % Material 1
               E,               AB,        IzB;  % Material 2
];

% Material connectivities
%  Tmat(e) = Row in mat corresponding to the material associated to element e 
data.Tmat = [
    1; % Element 1-2 / Material 1 (A)
    1; % Element 2-3 / Material 1 (A)
    1; % Element 3-4 / Material 1 (A)
    2; % Element 3-5 / Material 2 (B)
];

% Calculation of the problem variables
Pmax = 580538.461538462;
R6 = 333512.746929554;
N2s = 587999.205510907;

% Bar 1-6 section area
A16 = R6/sig_rot;

% Forces 
data.Fdata = [
    1 2 N2s;
    1 2 -R6*sin_e16;
    1 1 -R6*cos_e16;
    2 2 -Pmax/2*tan_e27;
    2 1 Pmax/2;
    ];

% Fixed nodes
data.fixNode = [
    4 1 0;
    4 2 0;
    4 3 0;   
    5 1 0;
    5 2 0;
    5 3 0; 
    ];
           
    

% Dimensions
dim.nd = size(data.x,2);              % Number of dimensions
dim.ni = 3;                      % Number of DOFs for each node
dim.n = size(data.x,1);               % Total number of nodes
dim.ndof = dim.ni*dim.n;                 % Total number of degrees of freedom
dim.nne = size(data.Tnod,2);            % Number of nodes for each element
dim.nelDOF = dim.ni*dim.nne;             % Number of DOFs for each element 
dim.nel = size(data.Tnod,1);

% Expected Results
displacement = [-0.113089885347818;0.000545745811563641;-0.184678309380802;-0.0511378511807242;7.31277774549792e-05;-0.146910332630846;-0.00532026958158725;-8.93400464261551e-05;-0.0428965220661880;0;0;0;0;0;0];
