classdef KglobalAssembler < handle

    
    properties (Access = public)
        kg
    end
    
    properties (Access = private)
        Td
        K
        R
        dim
        data
    end
    methods
        function obj = KglobalAssembler(cParams)
            obj.loadData(cParams);
        end
        
        function obj = loadData(obj,cParams)
            obj.dim = cParams.dim;
            obj.data = cParams.data;
            obj.Td = cParams.Td;
            obj.K = cParams.K;
            obj.R = cParams.R;
        end
        
        function obj = assembleKglobal(obj)
            
        s = obj.Td;
        nel = obj.dim.nel;
        nelDOF = obj.dim.nelDOF;
        
        Kg = zeros(obj.dim.ndof,obj.dim.ndof);
        Kel = obj.K;
        

            for e = 1:nel
                Kel(:,:,e) = transpose(obj.R(:,:,e))*obj.K(:,:,e)*obj.R(:,:,e);
                for i = 1:nelDOF
                    I = s(e,i);
                    for j = 1:nelDOF
                        J = s(e,j);
                        Kg(I,J)=Kg(I,J)+Kel(i,j,e);
                    end
                end
            end
         obj.kg = Kg;
        end
    end
end

