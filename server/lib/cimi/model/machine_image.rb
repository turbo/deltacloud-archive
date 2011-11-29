# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.  The
# ASF licenses this file to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance with the
# License.  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
# License for the specific language governing permissions and limitations
# under the License.

class CIMI::Model::MachineImage < CIMI::Model::Base

  href :image_location
  text :image_data

  array :operations do
    scalar :rel, :href
  end

  def self.find(id, _self)
    images = []
    if id == :all
      images = _self.driver.images(_self.credentials)
      images.map { |image| from_image(image, _self) }
    else
      image = _self.driver.image(_self.credentials, :id => id)
      from_image(image, _self)
    end
  end

  def self.from_image(image, _self)
    self.new(
      :name => image.id,
      :uri => _self.machine_image_url(image.id),
      :description => image.description,
      :image_location => { :href => "#{_self.driver.name}://#{image.id}" } # FIXME
    )
  end

end
