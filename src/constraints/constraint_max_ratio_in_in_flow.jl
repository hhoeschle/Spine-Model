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
    constraint_max_ratio_in_in_flow(m::Model)

Maximum ratio between the input `flow` of two `commodity_group`s
for each `unit` for which the parameter `max_ratio_in_in`
is specified.
"""
@catch_undef function constraint_max_ratio_in_in_flow(m::Model)
    @fetch flow = m.ext[:variables]
    constr_dict = m.ext[:constraints][:max_ratio_in_in_flow] = Dict()
    for (u, c1, c2) in indices(max_ratio_in_in_flow)
        involved_timeslices = [t for (u, n, c, d, t) in flow_indices(unit=u, commodity=[c1, c2])]
        for t in t_lowest_resolution(involved_timeslices)
            constr_dict[u, c1, c2, t] = @constraint(
                m,
                + sum(
                    flow[u_, n, c1_, d, t1] * duration(t1)
                    for (u_, n, c1_, d, t1) in flow_indices(
                        unit=u,
                        commodity=c1,
                        direction=:from_node,
                        t=t_in_t(t_long=t)
                    )
                )
                <=
                + max_ratio_in_in_flow(unit=u, commodity1=c1, commodity2=c2, t=t)
                * sum(
                    flow[u_, n, c2_, d, t1] * duration(t1)
                    for (u_, n, c2_, d, t1) in flow_indices(
                        unit=u,
                        commodity=c2,
                        direction=:from_node,
                        t=t_in_t(t_long=t)
                    )
                )
            )
        end
    end
end
