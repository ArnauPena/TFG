classdef StifnessMatrixComputer < handle
    
    properties (Access = private)
        data
        dim
        Td
        R
        K
        x1,x2
        y1,y2
        l
    end
    
    properties (Access = public)
        Kg
    end
    
    methods (Access = public)
        function obj = StifnessMatrixComputer(cParams)
            obj.init(cParams);
        end
        
        function obj = computeStifnessMatrix(obj)
            
            obj.computeConnectivityMatrix();
            obj.computeRotationMatrix();
            obj.computeK();
            obj.assembleKglobal();
                   
        end
    end
    
    methods (Access = private)
        
        function obj = computeConnectivityMatrix(obj)
            nel = obj.dim.nel;
            ni  = obj.dim.ni;
            nne = obj.dim.nne;
            vtd = zeros(nel,nne*ni);
            
            for e = 1:nel
                for i = 1:nne
                    for j = 1:ni
                        I = ni*(i-1)+j;
                        vtd(e,I)= ni*(obj.data.Tnod(e,i)-1)+j;
                    end
                end
            end
            obj.Td = vtd;
        end
        
        function obj = computeRotationMatrix(obj)
            obj.computeGeometry();
            r = zeros(6,6,obj.dim.nel);
            dx = obj.x2-obj.x1;
            dy = obj.y2-obj.y1;
            
            for e = 1:obj.dim.nel
                r(1,1:2,e) = 1/obj.l(e)*[dx(e) dy(e)];
                r(2,1:2,e) = 1/obj.l(e)*[-dy(e) dx(e)];
                r(3,3,e)   = 1/obj.l(e);
                r(4,4:5,e) = 1/obj.l(e)*[dx(e) dy(e)];
                r(5,4:5,e) = 1/obj.l(e)*[-dy(e) dx(e)];
                r(6,6,e)   = 1/obj.l(e);
            end
            obj.R = r;
        end
        
        function obj = computeK(obj)
            c = obj.data.mat;
            d = obj.data.Tmat;
            k = zeros(6,6,obj.dim.nel);
            L = obj.l;
            
            for e = 1:obj.dim.nel
                val = 1/L(e)^3*c(d(e),3)*c(d(e),1);
                val2 = c(d(e),1)*c(d(e),2)/L(e);
                k(1,1,e)   = val2;
                k(1,4,e)   = -val2;
                k(2,2:3,e) = val*[12 6*L(e)];
                k(2,5:6,e) = val*[-12 6*L(e)];
                k(3,2:3,e) = val*[6*L(e) 4*L(e)^2];
                k(3,5:6,e) = val*[6*L(e) 2*L(e)^2];
                k(4,1,e)   = -val2;
                k(4,4,e)   = val2;
                k(5,2:3,e) = val*[-12 -6*L(e)];
                k(5,5:6,e) = val*[12 -6*L(e)];
                k(6,2:3,e) = val*[6*L(e) 2*L(e)^2];
                k(6,5:6,e) = val*[-6*L(e) 4*L(e)^2];                
            end
            obj.K = k;
        end
        
        function obj = assembleKglobal(obj)
            
        nel = obj.dim.nel;
        nelDOF = obj.dim.nelDOF;        
        kg = zeros(obj.dim.ndof,obj.dim.ndof);
        Kel = obj.K;
        
            for e = 1:nel
                Kel(:,:,e) = transpose(obj.R(:,:,e))*obj.K(:,:,e)*obj.R(:,:,e);
                for i = 1:nelDOF
                    I = s(e,i);
                    for j = 1:nelDOF
                        J = s(e,j);
                        kg(I,J)=kg(I,J)+Kel(i,j,e);
                    end
                end
            end
         obj.Kg = kg;
        end
        
        function obj = computeGeometry(obj)
            a = obj.data.x;
            b = obj.data.Tnod;
            e = 1:obj.dim.nel;
            obj.x1 = a(b(e,1),1);
            obj.x2 = a(b(e,2),1);
            obj.y1 = a(b(e,1),2);
            obj.y2 = a(b(e,2),2);
            obj.l = sqrt((obj.x2-obj.x1).^2+(obj.y2-obj.y1).^2);            
        end
       
        function obj = init(cParams,obj)
            obj.data = cParams.data;
            obj.dim  = cParams.dim;
        end
        
    end
    
end

