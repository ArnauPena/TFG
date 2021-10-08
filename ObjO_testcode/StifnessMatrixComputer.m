classdef StifnessMatrixComputer < handle
    
    properties (Access = private)
        data
        dim
        connectivityMatrix
        rotationMatrix
        elementMatrix
        x1,x2
        y1,y2
        dX, dY
        l
    end
    
    properties (Access = public)
        stifnessMatrix
    end
    
    methods (Access = public)
        
        function obj = StifnessMatrixComputer(cParams)
            obj.init(cParams);
        end
        
        function obj = compute(obj)           
            obj.computeConnectivityMatrix();
            obj.computeRotationMatrix();
            obj.computeFirstNodeElementMatrix();
            obj.computeSecondNodeElementMatrix();
            obj.rotateElementMatrix();
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
            Td = zeros(nel,nne*ni);
            
            for iElement = 1:nel
                for iNode = 1:nne
                    for iDOF = 1:ni
                        I = ni*(iNode-1)+iDOF;
                        Td(iElement,I)= ni*(obj.data.Tnod(iElement,iNode)-1)+iDOF;
                    end
                end
            end
            obj.connectivityMatrix = Td;
        end
        
        function obj = computeRotationMatrix(obj)
            obj.computeGeometry();
            R = zeros(6,6,obj.dim.nel);
            dx = obj.dX;
            dy = obj.dY;
            L  = obj.l;
            for iElem = 1:obj.dim.nel
                c1     = [dx(iElem) dy(iElem)];
                c2     = [-dy(iElem) dx(iElem)];
                Length = L(iElem);
                R(1,1:2,iElem) = c1;
                R(2,1:2,iElem) = c2;
                R(3,3,iElem)   = Length;
                R(4,4:5,iElem) = c1;
                R(5,4:5,iElem) = c2;
                R(6,6,iElem)   = Length;
                R(:,:,iElem)   = R(:,:,iElem)/Length;
            end
            obj.rotationMatrix = R;
        end
        
        function obj = computeGeometry(obj)
            obj.computePositionVectors();
            obj.computeElementDistanceVector();
            obj.computeElementLength();
        end
        
        function obj = computePositionVectors(obj)
            a        = obj.data.x;
            b        = obj.data.Tnod;
            iElem    = 1:obj.dim.nel;
            obj.x1   = a(b(iElem,1),1);
            obj.x2   = a(b(iElem,2),1);
            obj.y1   = a(b(iElem,1),2);
            obj.y2   = a(b(iElem,2),2);
        end
        
        function obj = computeElementDistanceVector(obj)
            obj.dX = obj.x2 - obj.x1;
            obj.dY = obj.y2 - obj.y1;
        end
        
        function obj = computeElementLength(obj)
            obj.l = sqrt((obj.dX).^2+(obj.dY).^2);
        end
        
        function obj = computeFirstNodeElementMatrix(obj)
            c   = obj.dim.nelDOF;
            d   = obj.dim.nel;
            Kel = zeros(c,c,d);
            for iElem = 1:obj.dim.nel
                [c1,c2,c3,c4,c5,c6,c7,c8] = obj.computeCoeffs(iElem);
                Kel(1,1,iElem)   = c2;
                Kel(1,4,iElem)   = -c2;
                Kel(2,2:3,iElem) = c1*c3;
                Kel(2,5:6,iElem) = c1*c4;
                Kel(3,2:3,iElem) = c1*c5;
                Kel(3,5:6,iElem) = c1*c6;
            end
            obj.elementMatrix = Kel;
        end
        
        function obj = computeSecondNodeElementMatrix(obj)
            c   = obj.dim.nelDOF;
            d   = obj.dim.nel;
            Kel = zeros(c,c,d);
            for iElem = 1:obj.dim.nel
                [c1,c2,c3,c4,c5,c6,c7,c8] = obj.computeCoeffs(iElem);
                Kel(4,1,iElem)   = -c2;
                Kel(4,4,iElem)   = c2;
                Kel(5,2:3,iElem) = -c1*c3;
                Kel(5,5:6,iElem) = -c1*c4;
                Kel(6,2:3,iElem) = c1*c7;
                Kel(6,5:6,iElem) = c1*c8;
            end
            obj.elementMatrix = obj.elementMatrix + Kel;
        end
        
        function [c1,c2,c3,c4,c5,c6,c7,c8] = computeCoeffs(obj,iElem)
            a  = obj.data.mat;
            b  = obj.data.Tmat;
            L  = obj.l;
            c1 = 1/(L(iElem)^3)*a(b(iElem),3)*a(b(iElem),1);
            c2 = a(b(iElem),1)*a(b(iElem),2)/L(iElem);
            c3 = [12 6*L(iElem)];
            c4 = [-12 6*L(iElem)];
            c5 = [6*L(iElem) 4*L(iElem)^2];
            c6 = [-6*L(iElem) 2*L(iElem)^2];
            c7 = [6*L(iElem) 2*L(iElem)^2];
            c8 = [-6*L(iElem) 4*L(iElem)^2];
        end
                
        function obj = rotateElementMatrix(obj)
            K = obj.elementMatrix;
            R = obj.rotationMatrix;
            for iElem = 1:obj.dim.nel
                K(:,:,iElem) = (R(:,:,iElem)).'*K(:,:,iElem)*R(:,:,iElem);
            end
            obj.elementMatrix = K;
        end
        
        function obj = assembleKglobal(obj)
            s      = obj.connectivityMatrix;
            nel    = obj.dim.nel;
            nelDOF = obj.dim.nelDOF;
            Kg    = zeros(obj.dim.ndof,obj.dim.ndof);
            K      = obj.elementMatrix;
            for iElem = 1:nel
                for iRow = 1:nelDOF
                    I = s(iElem,iRow);
                    for iColumn = 1:nelDOF
                        J = s(iElem,iColumn);
                        Kg(I,J)=Kg(I,J)+K(iRow,iColumn,iElem);
                    end
                end
            end
            obj.stifnessMatrix = Kg;
        end
        
    end
    
end

