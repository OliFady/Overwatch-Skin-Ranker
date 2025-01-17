defmodule SkinRank.Skin do
  import Ecto.Query
  alias SkinRank.Skins.{Vote}
  alias SkinRank.{Messaging, Repo}

  def new_vote(skin_id) do
    SkinRank.Skins.Vote.create_changeset(%{skin_id: skin_id})
    |> SkinRank.Repo.insert!()
    |> SkinRank.Characters.notify_subscribers("votes", {:new_vote, skin_id})
  end

  def top_10_skins() do
    from(v in Vote,
      join: s in assoc(v, :skin),
      join: c in assoc(s, :character),
      select: {s, c, count(v.skin_id)},
      group_by: [s.id, c.id],
      order_by: [desc: count(v.skin_id)],
      limit: 10
    )
    |> Repo.all()
  end
end
