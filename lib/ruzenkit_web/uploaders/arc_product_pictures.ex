defmodule Ruzenkit.ArcProductPictures do
  use Arc.Definition

  # Include ecto support (requires package arc_ecto installed):
  use Arc.Ecto.Definition

  def __storage, do: Arc.Storage.Local # Add this

  @versions [:original]

  # To add a thumbnail version:
  @versions [:original, :thumb]

  # Override the bucket on a per definition basis:
  # def bucket do
  #   :custom_bucket_name
  # end

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  end

  # Define a thumbnail transformation:
  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 250x250^ -gravity center -extent 250x250 -format png", :png}
  end

  # Override the persisted filenames:

  # def filename(version, {file, _scope}) do
  #   file_name = Path.basename(file.file_name, Path.extname(file.file_name))
  #   "#{version}_#{file_name}"
  # end

  def filename(version, _) do
    version
  end

  # Override the storage directory:
  def storage_dir(_version, {_file, %{id: id}}) do
    IO.puts "IDDDD #{id}"
    Application.app_dir(:ruzenkit, "priv")
    |> Path.join("uploads/products/#{id}/pictures/")
    # "priv/uploads/products/#{scope.sku}/pictures/"
  end

  # Provide a default URL if there hasn't been a file uploaded
  def default_url(version, _scope) do
    # "/images/avatars/default_#{version}.png"
    # Application.app_dir(:ruzenkit, "priv")
    # |> Path.join("uploads/products/default/pictures/#{version}.png")
    "/uploads/products/default/pictures/#{version}.png"
  end

  # Specify custom headers for s3 objects
  # Available options are [:cache_control, :content_disposition,
  #    :content_encoding, :content_length, :content_type,
  #    :expect, :expires, :storage_class, :website_redirect_location]
  #
  # def s3_object_headers(version, {file, scope}) do
  #   [content_type: MIME.from_path(file.file_name)]
  # end
end
