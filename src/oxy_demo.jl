using Oxygen, JuliaHub, HTTP

println(pwd())
# always auth before any JH CRUD
# NB:  the return Authentication object is cached globally and does not need to be explicitly "stored"

ENV["JULIA_PKG_SERVER"] = "juliahub.com"

JuliaHub.authenticate()

# upload a dataset x

# these two struct fields would come from the planeview UI
struct DataUpload
    datasetName::String
    localPath::String
end

struct uploadState
    create::Bool
    replace::Bool
    update::Bool
end


# dummy values
# use `touch` in CLI to create `dummy_data_file` in local path
#
dataName = "dummy_data"
localPath = "./oxy_demo/src/dummy_data_file.txt"

dataToUpload = DataUpload(dataName,localPath)


#* `create :: Bool` (default: `true`): Create the dataset, if it already does not exist.
##* `update :: Bool` (default: `false`): Upload the data as a new dataset version, if the dataset exists.
#* `replace :: Bool` (default: `false`): If a dataset exists, delete all existing data and create a new
#  dataset with the same name instead. Excludes `update = true`, and only creates a completely new dataset
#  if `create=true` as well.


# this will decide _which_ version of upload_dataset to execute
uploadOption = uploadState(true,false,true)

# make sure uploading options OK
if !uploadOption.create && !uploadOption.update
    throw(ArgumentError("'create' and 'update' can not both be false"))
elseif uploadOption.update && uploadOption.replace
    throw(ArgumentError("'update' and 'replace' can not both be true"))
end

try
    JuliaHub.upload_dataset(dataToUpload.datasetName, dataToUpload.localPath,create=uploadOption.create,update=uploadOption.update,replace=uploadOption.replace)
catch e
    println("Upload failed!")
    throw(e)
else  
    println("Upload successful")
end

     

# get datasets for auth user - this is by default scoped w.r.t. his access rights in JH
function get_datasets()
    
    JuliaHub.datasets()

end 

#get_datasets()