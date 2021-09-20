classdef ConnectionMatrix
    
    properties
        td
    end
    
    methods (Access = public)
        function obj = ConnectionMatrix(cParams)
            computeConnectionMatrix();
        end
    end
    methods (Access = private)
        function obj = computeConnectionMatrix(cParams,obj)
            vtd = zeros(cParams.dim.nel,cParams.dim.nne*cParams.dim.ni);
            for e = 1:cParams.dim.nel
                for i = 1:cParams.dim.nne
                    for j = 1:cParams.dim.ni
                        I = cParams.dim.ni*(i-1)+j;
                        vtd(e,I)= cParams.dim.ni*(cParams.data.Tnod(e,i)-1)+j;
                    end
                end
            end
            obj.td = vtd;
        end
    end
end

