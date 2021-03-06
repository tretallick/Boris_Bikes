require './lib/bike_container'

class ContainerHolder; include BikeContainer; end
class User; end

describe BikeContainer do 

  let(:bike) { Bike.new }
  let(:holder) { ContainerHolder.new }

  it "should accept a bike" do
    expect(holder.bike_count).to eq(0)
    holder.dock(bike)
    expect(holder.bike_count).to eq(1)
  end

  it "should release a bike" do
    holder.dock(bike)
    holder.release(bike)
    expect(holder.bike_count).to eq(0)
  end

  it "should know when it is full" do
    expect(holder).not_to be_full
    fill_holder(holder)
    expect(holder).to be_full
  end

  it "should not accept a bike if it's full" do
    fill_holder(holder)
    expect { holder.dock(bike) }.to raise_error(RuntimeError)
  end

  it "should not release a bike if empty" do 
    holder.dock(bike)
    holder.release(bike)
    expect {holder.release(bike)}.to raise_error(RuntimeError)
  end

  it "should not release a bike if its not a bike" do
    bike = 34
    fill_holder(holder)
    holder.release(bike)
    expect(holder.bike_count).to eq(10)
  end

  it "should not dock a bike if it's not a bike" do
    bike = 34
    holder.dock(bike)
    expect(holder.bike_count).to eq(0)
  end

  it "should provide the list of available bikes" do
    working_bike, broken_bike = Bike.new, Bike.new
    broken_bike.break
    holder.dock(working_bike)
    holder.dock(broken_bike)
    expect(holder.available_bikes).to eq([working_bike])
  end

  it "should provide a list of broken bikes" do
    working_bike, broken_bike = Bike.new, Bike.new
    broken_bike.break
    holder.dock(working_bike)
    holder.dock(broken_bike)
    expect(holder.broken_bikes).to eq([broken_bike])
  end

  def fill_holder(holder)
    holder.capacity.times { holder.dock(Bike.new) }
  end
  
end