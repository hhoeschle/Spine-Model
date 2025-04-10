#############################################################################
# Copyright (C) 2017 - 2018  Spine Project
#
# This file is part of Spine Model.
#
# Spine Model is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Spine Model is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#############################################################################

"""
    renewable_curtailment_costs(m::Model)

Variable operation costs defined on flows.
"""
function renewable_curtailment_costs(m::Model)
    let rcc_costs = zero(AffExpr)
        for (n,t) in curtailment_ren_indices()
            add_to_expression!(rcc_costs, renewable_curtailment_cost(node=n) * curtailment_ren[n,t])
        end
        rccm_costs
    end
end
