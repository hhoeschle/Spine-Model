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
    start_up_costs(m::Model)

Startup cost term for units.
"""
function start_up_costs(m::Model)
    @fetch units_started_up = m.ext[:variables]
    @expression(
        m,
        reduce(
            +,
            start_up_cost(unit=u) * units_started_up[u, t]
            for (u, t) in units_on_indices() if start_up_cost(unit=u) != nothing; 
            init=0
        )
    )
end
