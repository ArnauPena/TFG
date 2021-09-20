classdef FEMcomputer < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        staticfiledata
        data
        dim
        displacement
        Td
        Kel, Kglobal, Fext
        ur, vr, vl, u, ul
        Kll,Krr,Krl,Klr,Fl,Fr,Rr
        Fx, Fy, Mz
        scase
    end
    
    methods (Access = public)
        function obj = FEMcomputer(staticFileData)
            obj.staticfiledata = staticFileData;
            obj.loadData();
        end
    end
    methods (Access = public)
        function loadData(obj)
            run(obj.staticFileData);
            obj.data = data;
            obj.dim = dim;
            obj.displacement = displacement;
        end
    end
    methods (Access = public)        
        function obj = solve(obj)
            obj.connectDOF();%
            obj.computeKelement();
            obj.computeForce();%
            obj.assemblyKglobal();
            obj.computePart();
            obj.computedispl();%
        end
        
    end
    
    methods (Access = private)
        function obj = computeStifnessMatrix(obj)
           k = StifnessMatrixComputer();
           obj.K = k.compute();
        end
        function obj = computeConnectMatrix(obj)
            vTd = zeros(obj.dim.nel,obj.dim.nne*obj.dim.ni);
            for e = 1:obj.dim.nel
                for i = 1:obj.dim.nne
                    for j = 1:obj.dim.ni
                        I = obj.dim.ni*(i-1)+j; % From node to DOF
                        vTd(e,I)= obj.dim.ni*(obj.data.Tnod(e,i)-1)+j;
                    end
                end
            end
            obj.Td = vTd;
        end
        
        function computeKelement(obj)
            Kels=zeros(6,6,obj.dim.nel);
            for e = 1:obj.dim.nel
                % Computing node's initial position
                x1 = obj.data.x(obj.data.Tnod(e,1),1);
                x2 = obj.data.x(obj.data.Tnod(e,2),1);
                y1 = obj.data.x(obj.data.Tnod(e,1),2);
                y2 = obj.data.x(obj.data.Tnod(e,2),2);
                l = sqrt((x2-x1)^2+(y2-y1)^2); % Element length
                R = 1/l*[x2-x1 y2-y1 0 0 0 0;
                    -(y2-y1) x2-x1 0 0 0 0;
                    0 0 l 0 0 0;
                    0 0 0 x2-x1 y2-y1 0;
                    0 0 0 -(y2-y1) x2-x1 0;
                    0 0 0 0 0 l];
                
                K = 1/l^3*obj.data.mat(obj.data.Tmat(e),3)*obj.data.mat(obj.data.Tmat(e),1)*...
                    [0 0 0 0 0 0;
                    0 12 6*l 0 -12 6*l;
                    0 6*l 4*l^2 0 -6*l 2*l^2;
                    0 0 0 0 0 0;
                    0 -12 -6*l 0 12 -6*l;
                    0 6*l 2*l^2 0 -6*l 4*l^2] + ...
                    obj.data.mat(obj.data.Tmat(e),1)*obj.data.mat(obj.data.Tmat(e),2)/l*...
                    [1 0 0 -1 0 0;
                    0 0 0 0 0 0;
                    0 0 0 0 0 0;
                    -1 0 0 1 0 0;
                    0 0 0 0 0 0;
                    0 0 0 0 0 0];
                % Stifness matrix
                Kels(:,:,e)=Kels(:,:,e)+R.'*K*R;
            end
            obj.Kel = Kels;
        end
        
        function computeForce(obj)
            Fexts=zeros(obj.dim.ndof,1); % Predefining external force vector
            
            for k = 1:size(obj.data.Fdata,1)
                Node = obj.data.Fdata(k,1); % Node number
                DOF = obj.data.Fdata(k,2); % DOF (x,y,z,...)
                Fmag = obj.data.Fdata(k,3); % Magnitude
                % Works only with 3 DOF
                if DOF==1
                    Fexts(3*Node-2,1) = Fexts(3*Node-2,1) + Fmag;
                end
                if DOF==2
                    Fexts(3*Node-1,1) = Fexts(3*Node-1,1) + Fmag;
                end
                if DOF==3
                    Fexts(3*Node,1) = Fexts(3*Node,1) + Fmag;
                end
            end
            obj.Fext = Fexts;
           
        end
        
        function assemblyKglobal(obj)
            Kglobals = zeros(obj.dim.ndof,obj.dim.ndof); % Predefining global stifness matrix size


            for e = 1:obj.dim.nel
                for i = 1:obj.dim.nelDOF
                    I = obj.Td(e,i); % Corresponfing to global DOF
                    for j = 1:obj.dim.nelDOF
                        J = obj.Td(e,j); % Corresponfing to global DOF
                        Kglobals(I,J)=Kglobals(I,J)+obj.Kel(i,j,e);
                    end
                end
            end
            obj.Kglobal = Kglobals;
        end
        
        function computePart(obj)
            % Determining restricted and free DOFs
            vrs=size(obj.data.fixNode,1); % Predefining restricted DOF vector
            urs=size(obj.data.fixNode,1); % Predefining imposed displacement vector
            
            for k = 1:size(obj.data.fixNode,1)
                Node = obj.data.fixNode(k,1); % Node
                DOF = obj.data.fixNode(k,2); % DOF (1,2,...)
                Displacement = obj.data.fixNode(k,3); % Imposed displacement
                % Only works for 2 DOF
                if DOF==1
                    vrs(k,1) = 3*Node-2;
                end
                if DOF==2
                    vrs(k,1) = 3*Node-1;
                end
                if DOF==3
                    vrs(k,1) = 3*Node;
                end
                urs(k,1)=Displacement;
            end
            j=[1:obj.dim.ndof].';
            vls=j; % Predifining free displacement vector with all DOF
            for k = 1:obj.dim.ndof
                % Changing to 0 DOF with imposed displacement (vr)
                Fixed = any(vrs(:) == j(k));
                if Fixed
                    vls(k)=0;
                end
            end
            vls(vls==0)=[]; % Eliminating restricted DOF
            
            % Partioning global matrix
            
            % Assembling partioned matrix
            Klls=obj.Kglobal(vls,vls);
            Krrs=obj.Kglobal(vrs,vrs);
            Krls=obj.Kglobal(vrs,vls);
            Klrs=obj.Kglobal(vls,vrs);
            
            % External force vectors
            Frs=size(vrs,1); % Predifining external force to restricted DOF vector
            Fls=size(vls,1); % Predifining external force to free DOF vector
            
            for i=1:length(vrs)
                Frs(i,1)=obj.Fext(vrs(i));
            end
            for i=1:length(vls)
                Fls(i,1)=obj.Fext(vls(i));
            end
            
            % Equation solution
            uls = Klls\(Fls-Klrs*urs); % Displacement equation
            Rrs= Krrs*urs+Krls*uls-Frs; % Reaction of the restricted DOF
            
            % Objects
            obj.vl = vls;
            obj.vr = vrs;
            obj.ur = urs;
            obj.Kll = Klls;
            obj.Krr = Krrs;
            obj.Krl = Krls;
            obj.Klr = Klrs;
            obj.Fr = Frs;
            obj.Fl = Fls;
            
            
            obj.ul = uls;
            obj.Rr = Rrs;
        end
        
        
        function computedispl(obj)
            us=size(obj.dim.ndof,1);
            Fx_els = zeros(obj.dim.nel,2);
            Fy_els = zeros(obj.dim.nel,2);
            Mz_els = zeros(obj.dim.nel,2);
            
            % Reassembling displacement vector
            us(obj.vl,1) = obj.ul;
            us(obj.vr,1) = obj.ur;
            
            for e=1:obj.dim.nel
                for i=1:(obj.dim.ni*obj.dim.nne)
                    I=obj.Td(e,i);
                    ue(i,1)=us(I,1); % Reorganizing displacements from DOF to element
                end
                % Computing node's initial position
                x1 = obj.data.x(obj.data.Tnod(e,1),1);
                x2 = obj.data.x(obj.data.Tnod(e,2),1);
                y1 = obj.data.x(obj.data.Tnod(e,1),2);
                y2 = obj.data.x(obj.data.Tnod(e,2),2);
                l = sqrt((x2-x1)^2+(y2-y1)^2); % Element length
                R = 1/l*[x2-x1 y2-y1 0 0 0 0;
                    -(y2-y1) x2-x1 0 0 0 0;
                    0 0 l 0 0 0;
                    0 0 0 x2-x1 y2-y1 0;
                    0 0 0 -(y2-y1) x2-x1 0;
                    0 0 0 0 0 l];
                
                Fint = R*obj.Kel(:,:,e)*ue;
                % Axial Force
                Fx_els(e,1)=-Fint(1);
                Fx_els(e,2)=Fint(4);
                % Shear Force
                Fy_els(e,1)=-Fint(2);
                Fy_els(e,2)=Fint(5);
                % Bending Moment
                Mz_els(e,1)=-Fint(3);
                Mz_els(e,2)=Fint(6);
                
            end
            
            obj.u = us;
            obj.Fx = Fx_els;
            obj.Fy = Fy_els;
            obj.Mz = Mz_els;
        end
        

        
    end 
end 
         
        
        


