classdef StifnessMatrixComputer < handle
    
    properties (Access = private)
        data
        dim
        Td
        R
        Kel
        x1,x2
        y1,y2
        dX, dY
        l
    end
    
    properties (Access = public)
        Kg
    end
    
    methods (Access = public)
        function obj = StifnessMatrixComputer(cParams)
            obj.init(cParams);
        end
        
        function obj = compute(obj)           
            obj.computeConnectivityMatrix();
            obj.computeRotationMatrix();
            obj.computeK();
            obj.assembleKglobal();
        end
    end
    
    methods (Access = private)
        
        function obj = init(obj,cParams)
            obj.data = cParams.data;
            obj.dim  = cParams.dim;
        end
        
        function obj = computeConnectivityMatrix(obj)
            nel = obj.dim.nel;
            ni  = obj.dim.ni;
            nne = obj.dim.nne;
            Tdv = zeros(nel,nne*ni);
            
            for iElement = 1:nel
                for iNode = 1:nne
                    for iDOF = 1:ni
                        I = ni*(iNode-1)+iDOF;
                        Tdv(iElement,I)= ni*(obj.data.Tnod(iElement,iNode)-1)+iDOF;
                    end
                end
            end
            obj.Td = Tdv;
        end
        
        function obj = computeRotationMatrix(obj)
            obj.computeGeometry();
            Rv = zeros(6,6,obj.dim.nel);
            dx = obj.dX;
            dy = obj.dY;
            L  = obj.l;
            for iElement = 1:obj.dim.nel
                Rv(1,1:2,iElement) = [dx(iElement) dy(iElement)];
                Rv(2,1:2,iElement) = [-dy(iElement) dx(iElement)];
                Rv(3,3,iElement)   = L(iElement);
                Rv(4,4:5,iElement) = [dx(iElement) dy(iElement)];
                Rv(5,4:5,iElement) = [-dy(iElement) dx(iElement)];
                Rv(6,6,iElement)   = L(iElement);
                Rv(:,:,iElement)   = Rv(:,:,iElement)/L(iElement);
            end
            obj.R = Rv;
        end
        
        function obj = computeK(obj)
            a = obj.data.mat;
            b = obj.data.Tmat;
            c = obj.dim.nelDOF;
            d = obj.dim.nel;
            Kelv = zeros(c,c,d);
            L = obj.l;
            for iElement = 1:obj.dim.nel
                val = 1/(L(iElement)^3)*a(b(iElement),3)*a(b(iElement),1);
                val2 = a(b(iElement),1)*a(b(iElement),2)/L(iElement);
                Kelv(1,1,iElement)   = val2;
                Kelv(1,4,iElement)   = -val2;
                Kelv(2,2:3,iElement) = val*[12 6*L(iElement)];
                Kelv(2,5:6,iElement) = val*[-12 6*L(iElement)];
                Kelv(3,2:3,iElement) = val*[6*L(iElement) 4*L(iElement)^2];
                Kelv(3,5:6,iElement) = val*[-6*L(iElement) 2*L(iElement)^2];
                Kelv(4,1,iElement)   = -val2;
                Kelv(4,4,iElement)   = val2;
                Kelv(5,2:3,iElement) = val*[-12 -6*L(iElement)];
                Kelv(5,5:6,iElement) = val*[12 -6*L(iElement)];
                Kelv(6,2:3,iElement) = val*[6*L(iElement) 2*L(iElement)^2];
                Kelv(6,5:6,iElement) = val*[-6*L(iElement) 4*L(iElement)^2];
                Kelv(:,:,iElement)   = (obj.R(:,:,iElement)).'...
                *Kelv(:,:,iElement)*obj.R(:,:,iElement);
            end           
            obj.Kel = Kelv;
        end
        
        function obj = assembleKglobal(obj)
            s      = obj.Td;
            nel    = obj.dim.nel;
            nelDOF = obj.dim.nelDOF;
            Kgv    = zeros(obj.dim.ndof,obj.dim.ndof);
            K      = obj.Kel;
            for e = 1:nel
                for i = 1:nelDOF
                    I = s(e,i);
                    for j = 1:nelDOF
                        J = s(e,j);
                        Kgv(I,J)=Kgv(I,J)+K(i,j,e);
                    end
                end
            end
            obj.Kg = Kgv;
        end
        
        function obj = computeGeometry(obj)
            obj.computePositionVectors();
            obj.computeDistanceVector();
            obj.computeElementLength();            
        end
        
        function obj = computePositionVectors(obj)
            a        = obj.data.x;
            b        = obj.data.Tnod;           
            iElement = 1:obj.dim.nel;
            obj.x1   = a(b(iElement,1),1);
            obj.x2   = a(b(iElement,2),1);
            obj.y1   = a(b(iElement,1),2);
            obj.y2   = a(b(iElement,2),2);
           
        end
        
        function obj = computeDistanceVector(obj)
            obj.dX = obj.x2 - obj.x1;
            obj.dY = obj.y2 - obj.y1;
        end
        
        function obj = computeElementLength(obj)
            obj.l = sqrt((obj.dX).^2+(obj.dY).^2);
        end
        
    end
    
end

