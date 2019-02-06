defmodule Phelddagrif.Repo.Migrations.DropShiftedFields do
  use Ecto.Migration

  def change do
    alter table("cards") do
      remove :timeshifted
      remove :colorshifted
      remove :futureshifted
    end
  end
end
